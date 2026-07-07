from flask import Blueprint, render_template, request, jsonify, session, abort
import pymysql
from db import get_db_connection
from utils.permissions import check_permission
from utils.status_utils import normalize_db_status

admin_tickets_bp = Blueprint('admin_tickets_bp', __name__, template_folder='templates')


@admin_tickets_bp.route('/admin/tickets')
@check_permission('submit_ticket', 'view')
def admin_tickets_page():
    """Render admin ticket queue page."""
    # Allow optional `?status=` to focus a section (e.g., pending, ongoing)
    status_filter = (request.args.get('status') or '').strip().lower()
    if status_filter in ('inprogress', 'in-progress'):
        status_filter = 'ongoing'
    if not status_filter:
        status_filter = 'all'
    return render_template('admin_tickets.html', active_filter=status_filter)


@admin_tickets_bp.route('/admin/tickets/list')
@check_permission('submit_ticket', 'view')
def admin_tickets_list():
    """Return JSON list of tickets (joined with department names when available)."""
    conn = get_db_connection()
    try:
        # Ensure the tickets table exists to avoid ProgrammingError when empty DBs are used
        try:
            with conn.cursor() as _c:
                _c.execute(
                    """
                    CREATE TABLE IF NOT EXISTS tickets (
                        ticket_id INT AUTO_INCREMENT PRIMARY KEY,
                        user_id INT,
                        department_id INT NULL,
                        device_id INT NULL,
                        title VARCHAR(255),
                        description TEXT,
                        status VARCHAR(50) DEFAULT 'Open',
                        created_at DATETIME DEFAULT NOW()
                    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
                    """
                )
                # DDL is auto-committed in MySQL, but ensure connection state is flushed
                try:
                    conn.commit()
                except Exception:
                    pass
        except Exception:
            # best-effort: if we cannot create the table, continue and let subsequent queries fail gracefully
            pass
        # Support server-side filtering via query params: q, facility, device
        q = (request.args.get('q') or '').strip()
        facility = (request.args.get('facility') or '').strip()
        device = (request.args.get('device') or '').strip()

        sql = [
            "SELECT",
            "    t.ticket_id,",
            "    t.title,",
            "    t.description,",
            "    t.status,",
            "    t.created_at,",
            "    t.user_id,",
            "    d.department_name AS facility_name",
            "FROM tickets t",
            "LEFT JOIN departments d ON d.department_id = t.department_id"
        ]

        where = []
        params = []

        # filter by facility (department id or name)
        if facility:
            try:
                fid = int(facility)
                where.append("t.department_id = %s")
                params.append(fid)
            except Exception:
                where.append("d.department_name = %s")
                params.append(facility)

        # filter by device — if numeric try to filter by ticket_devices or tickets.device_id, else fallback to text search
        if device:
            # try numeric id
            try:
                did = int(device)
                # prefer ticket_devices association if available
                with conn.cursor() as _c:
                    _c.execute("SELECT COUNT(*) AS cnt FROM information_schema.TABLES WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'ticket_devices'")
                    td_exists = bool(_c.fetchone()[0])
                if td_exists:
                    where.append("t.ticket_id IN (SELECT ticket_id FROM ticket_devices WHERE device_id = %s)")
                    params.append(did)
                else:
                    # fallback to device_id column on tickets (if present)
                    with conn.cursor() as _c:
                        _c.execute("SELECT COUNT(*) AS cnt FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'tickets' AND COLUMN_NAME = 'device_id'")
                        has_devcol = bool(_c.fetchone()[0])
                    if has_devcol:
                        where.append("t.device_id = %s")
                        params.append(did)
                    else:
                        like = f"%{device}%"
                        where.append("(t.title LIKE %s OR t.description LIKE %s)")
                        params.extend([like, like])
            except Exception:
                like = f"%{device}%"
                where.append("(t.title LIKE %s OR t.description LIKE %s)")
                params.extend([like, like])

        # free-text search across title/description/user_id/facility
        if q:
            like = f"%{q}%"
            where.append("(t.title LIKE %s OR t.description LIKE %s OR t.user_id LIKE %s OR d.department_name LIKE %s)")
            params.extend([like, like, like, like])

        if where:
            sql.append("WHERE " + " AND ".join(where))

        sql.append("ORDER BY t.created_at DESC")

        final_sql = "\n".join(sql)
        with conn.cursor(pymysql.cursors.DictCursor) as cursor:
            cursor.execute(final_sql, params)
            rows = cursor.fetchall() or []

            # attach device lists per ticket if ticket_devices exists or tickets.device_id is present
            ticket_ids = [r['ticket_id'] for r in rows]
            if ticket_ids:
                try:
                    # check if ticket_devices exists
                    cursor.execute("SELECT COUNT(*) AS cnt FROM information_schema.TABLES WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'ticket_devices'")
                    has_td = bool(cursor.fetchone().get('cnt'))
                except Exception:
                    has_td = False

                if has_td:
                    # fetch device associations for all tickets in one query
                    placeholders = ','.join(['%s'] * len(ticket_ids))
                    q = ("SELECT td.ticket_id, td.device_id AS device_id, COALESCE(df.item_name, d.item_name) AS device_name "
                         "FROM ticket_devices td "
                         "LEFT JOIN devices_full df ON df.accession_id = td.device_id "
                         "LEFT JOIN devices d ON d.device_id = td.device_id "
                         f"WHERE td.ticket_id IN ({placeholders})")
                    cursor.execute(q, ticket_ids)
                    assoc = cursor.fetchall() or []
                    mapping = {}
                    for a in assoc:
                        tid = a['ticket_id']
                        mapping.setdefault(tid, []).append({'id': a.get('device_id'), 'name': a.get('device_name')})
                    for r in rows:
                        r['devices'] = mapping.get(r['ticket_id'], [])
                else:
                    # fallback: if tickets.device_id column exists, fetch device info for those device_ids
                    try:
                        cursor.execute("SELECT COUNT(*) AS cnt FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'tickets' AND COLUMN_NAME = 'device_id'")
                        has_devcol = bool(cursor.fetchone().get('cnt'))
                    except Exception:
                        has_devcol = False
                    if has_devcol:
                        # collect device ids
                        dids = [r.get('device_id') for r in rows if r.get('device_id')]
                        if dids:
                            placeholders = ','.join(['%s'] * len(dids))
                            q = ("SELECT COALESCE(df.accession_id, d.device_id) AS id, COALESCE(df.item_name, d.item_name) AS name, COALESCE(df.department_id, d.department_id) AS department_id "
                                 "FROM devices_full df LEFT JOIN devices d ON d.device_id = df.accession_id "
                                 f"WHERE COALESCE(df.accession_id, d.device_id) IN ({placeholders})")
                            cursor.execute(q, dids)
                            device_rows = cursor.fetchall() or []
                            devmap = {dr['id']: {'id': dr['id'], 'name': dr['name']} for dr in device_rows}
                            for r in rows:
                                did = r.get('device_id')
                                r['devices'] = [devmap.get(did)] if did and devmap.get(did) else []
                        else:
                            for r in rows:
                                r['devices'] = []
                    else:
                        for r in rows:
                            r['devices'] = []

            return jsonify(rows)
    finally:
        conn.close()


@admin_tickets_bp.route('/admin/tickets/filters/facilities')
@check_permission('submit_ticket', 'view')
def admin_tickets_facilities():
    """Return JSON list of facilities/departments for filter selects."""
    conn = get_db_connection()
    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cursor:
            cursor.execute("SELECT department_id, department_name FROM departments ORDER BY department_name")
            rows = cursor.fetchall() or []
            return jsonify(rows)
    finally:
        conn.close()


@admin_tickets_bp.route('/admin/tickets/filters/devices')
@check_permission('submit_ticket', 'view')
def admin_tickets_devices():
    """Return JSON list of devices (id,name,department_id) for filter selects."""
    conn = get_db_connection()
    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cursor:
            try:
                cursor.execute("SELECT df.accession_id AS id, df.item_name AS name, df.department_id, dep.department_name FROM devices_full df LEFT JOIN departments dep ON df.department_id = dep.department_id WHERE COALESCE(df.is_archived,0)=0 ORDER BY df.item_name")
                rows = cursor.fetchall() or []
                return jsonify(rows)
            except Exception:
                try:
                    cursor.execute("SELECT d.device_id AS id, d.item_name AS name, d.department_id, dep.department_name FROM devices d LEFT JOIN departments dep ON d.department_id = dep.department_id ORDER BY d.item_name")
                    rows = cursor.fetchall() or []
                    return jsonify(rows)
                except Exception:
                    return jsonify([])
    finally:
        conn.close()


@admin_tickets_bp.route('/admin/tickets/<int:ticket_id>/action', methods=['POST'])
def admin_ticket_action(ticket_id):
    """Admin action to accept or reject a ticket. Requires admin user."""
    user = session.get('user')
    if not user or not user.get('is_admin'):
        return jsonify({'status': 'error', 'message': 'Forbidden'}), 403

    # Accept either form-encoded 'action' or JSON {action: 'accept'|'reject'}
    action = (request.form.get('action') or (request.get_json(silent=True) or {}).get('action') or '').strip().lower()
    # Allow admin to accept/reject and also mark resolved/unresolved
    if action not in ('accept', 'reject', 'resolve', 'unresolve'):
        return jsonify({'status': 'error', 'message': 'Invalid action'}), 400

    if action == 'accept':
        new_status = 'Accepted'
    elif action == 'reject':
        new_status = 'Invalid'
    elif action == 'resolve':
        new_status = 'Resolved'
    else:
        new_status = 'Unresolved'

    # optional feedback/notes from admin (or bot) when resolving/unresolving
    feedback = (request.form.get('feedback') or (request.get_json(silent=True) or {}).get('feedback') or '').strip()
    # normalize to canonical DB status before writing
    new_status = normalize_db_status(new_status)
    conn = get_db_connection()
    try:
        # Ensure tickets table exists before attempting updates to avoid table-missing errors
        try:
            with conn.cursor() as _c:
                _c.execute(
                    """
                    CREATE TABLE IF NOT EXISTS tickets (
                        ticket_id INT AUTO_INCREMENT PRIMARY KEY,
                        user_id INT,
                        department_id INT NULL,
                        device_id INT NULL,
                        title VARCHAR(255),
                        description TEXT,
                        status VARCHAR(50) DEFAULT 'Open',
                        created_at DATETIME DEFAULT NOW()
                    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
                    """
                )
                try:
                    conn.commit()
                except Exception:
                    pass
        except Exception:
            pass
        # Ensure a responses table exists to store admin comments/feedback
        try:
            with conn.cursor() as _c:
                _c.execute(
                    """
                    CREATE TABLE IF NOT EXISTS ticket_responses (
                        id INT AUTO_INCREMENT PRIMARY KEY,
                        ticket_id INT NOT NULL,
                        responder_id INT NULL,
                        action VARCHAR(50),
                        feedback TEXT,
                        created_at DATETIME DEFAULT NOW()
                    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
                    """
                )
                try:
                    conn.commit()
                except Exception:
                    pass
        except Exception:
            # non-fatal: if we cannot create the table, continue and attempt to record the response later
            pass

        # Ensure tickets table has resolved_at and resolved_by_id columns (migration-safe)
        try:
            with conn.cursor() as _c:
                try:
                    _c.execute("SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'tickets' AND COLUMN_NAME = 'resolved_at'")
                    if not int(_c.fetchone()[0]):
                        _c.execute("ALTER TABLE tickets ADD COLUMN resolved_at DATETIME NULL AFTER created_at")
                except Exception:
                    pass
                try:
                    _c.execute("SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'tickets' AND COLUMN_NAME = 'resolved_by_id'")
                    if not int(_c.fetchone()[0]):
                        _c.execute("ALTER TABLE tickets ADD COLUMN resolved_by_id INT NULL AFTER resolved_at")
                except Exception:
                    pass
                try:
                    conn.commit()
                except Exception:
                    pass
        except Exception:
            pass

        # Update ticket status and set resolved metadata when applicable
        try:
            responder_id = user.get('user_id') if user else None
            with conn.cursor() as cursor:
                if action == 'resolve':
                    cursor.execute("UPDATE tickets SET status = %s, resolved_at = NOW(), resolved_by_id = %s WHERE ticket_id = %s", (new_status, responder_id, ticket_id))
                elif action == 'unresolve':
                    cursor.execute("UPDATE tickets SET status = %s, resolved_at = NULL, resolved_by_id = NULL WHERE ticket_id = %s", (new_status, ticket_id))
                else:
                    cursor.execute("UPDATE tickets SET status = %s WHERE ticket_id = %s", (new_status, ticket_id))
            conn.commit()
        except Exception:
            try:
                conn.rollback()
            except Exception:
                pass

        # persist the feedback/response (non-fatal)
        try:
            responder_id = user.get('user_id') if user else None
            with conn.cursor() as cursor:
                cursor.execute(
                    "INSERT INTO ticket_responses (ticket_id, responder_id, action, feedback) VALUES (%s, %s, %s, %s)",
                    (ticket_id, responder_id, action, feedback)
                )
            conn.commit()
        except Exception as exc:
            # don't fail the main request if logging the response fails — surface to console for diagnostics
            print(f"ADMIN TICKET RESPONSE LOG ERROR: {exc}")
        return jsonify({'status': 'success', 'message': f'Ticket {new_status.lower()}', 'new_status': new_status}), 200
    except Exception as exc:
        print(f"ADMIN TICKET ACTION ERROR: {exc}")
        return jsonify({'status': 'error', 'message': 'Failed to update ticket status'}), 500
    finally:
        conn.close()
