from flask import Blueprint, render_template, request, redirect, url_for, flash, session, jsonify
import pymysql
from db import get_db_connection
from utils.permissions import check_permission
from utils.status_utils import normalize_db_status

submit_ticket_bp = Blueprint('submit_ticket_bp', __name__, template_folder='templates')


@submit_ticket_bp.route('/submit-ticket', methods=['GET'])
@check_permission('submit_ticket', 'view')
def submit_ticket_page():
    """Render the Submit Ticket page."""
    conn = get_db_connection()
    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cursor:
            # Load all departments as facilities for the select (alias to id/name for template)
            cursor.execute("SELECT department_id AS id, department_name AS name FROM departments ORDER BY department_name")
            facilities = cursor.fetchall()
            # Load devices (devices_full preferred)
            try:
                cursor.execute("SELECT df.accession_id AS id, df.item_name AS name, df.department_id, dep.department_name FROM devices_full df LEFT JOIN departments dep ON df.department_id = dep.department_id WHERE COALESCE(df.is_archived,0)=0 ORDER BY df.item_name")
                devices = cursor.fetchall() or []
            except Exception:
                try:
                    cursor.execute("SELECT d.device_id AS id, d.item_name AS name, d.department_id, dep.department_name FROM devices d LEFT JOIN departments dep ON d.department_id = dep.department_id ORDER BY d.item_name")
                    devices = cursor.fetchall() or []
                except Exception:
                    devices = []
    except Exception:
        facilities = []
        devices = []
    finally:
        conn.close()
    return render_template('submit_ticket.html', facilities=facilities, devices=devices)


@submit_ticket_bp.route('/submit-ticket', methods=['POST'])
@check_permission('submit_ticket', 'add')
def submit_ticket_submit():
    """Handle ticket submission and persist to DB (creates table if needed)."""
    title = (request.form.get('title') or '').strip()
    description = (request.form.get('description') or '').strip()
    facility = (request.form.get('facility') or '').strip()
    try:
        facility_id = int(facility) if facility else None
    except ValueError:
        facility_id = None
    user = session.get('user') or {}
    user_id = user.get('user_id')

    # Detect AJAX requests (fetch/XHR) to return JSON responses
    is_ajax = request.headers.get('X-Requested-With') == 'XMLHttpRequest' or 'application/json' in (request.headers.get('Accept') or '')

    # Facility is optional (some installs may not have departments configured).
    if not title or not description:
        if is_ajax:
            return jsonify({'status': 'error', 'message': 'Title and description are required.'}), 400
        flash('Title and description are required.', 'error')
        return redirect(url_for('submit_ticket_bp.submit_ticket_page'))

    conn = get_db_connection()
    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cursor:
            # Ensure tickets table exists and includes department_id
            cursor.execute(
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
            # If an older tickets table exists without department_id, try to add it
            try:
                cursor.execute("SHOW COLUMNS FROM tickets")
                existing = {row['Field'] for row in cursor.fetchall()}
                if 'department_id' not in existing:
                    cursor.execute("ALTER TABLE tickets ADD COLUMN department_id INT NULL AFTER user_id")
                if 'device_id' not in existing:
                    cursor.execute("ALTER TABLE tickets ADD COLUMN device_id INT NULL AFTER department_id")
            except Exception:
                # non-fatal; proceed with insert
                pass
            # Accept devices list from form (multiple select); keep first as device_id for backwards compatibility
            device_ids = request.form.getlist('devices') or []
            primary_device_id = None
            try:
                if device_ids:
                    primary_device_id = int(device_ids[0])
            except Exception:
                primary_device_id = None

            cursor.execute(
                """
                INSERT INTO tickets (user_id, department_id, device_id, title, description, status, created_at)
                VALUES (%s, %s, %s, %s, %s, %s, NOW())
                """,
                 (user_id, facility_id, primary_device_id, title, description, normalize_db_status('Open'))
            )
            last_id = cursor.lastrowid

            # Ensure ticket_devices table exists and insert associations
            try:
                cursor.execute(
                    """
                    CREATE TABLE IF NOT EXISTS ticket_devices (
                        id INT AUTO_INCREMENT PRIMARY KEY,
                        ticket_id INT NOT NULL,
                        device_id INT NOT NULL
                    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
                    """
                )
                for did in device_ids:
                    try:
                        did_i = int(did)
                    except Exception:
                        continue
                    cursor.execute("INSERT INTO ticket_devices (ticket_id, device_id) VALUES (%s, %s)", (last_id, did_i))
            except Exception:
                # ignore ticket_devices creation/insert errors
                pass
        conn.commit()
        if is_ajax:
            return jsonify({'status': 'success', 'message': 'Ticket submitted successfully.', 'ticket_id': last_id}), 200
        flash('Ticket submitted successfully.', 'success')
        return redirect(url_for('submit_ticket_bp.submit_ticket_page'))
    except Exception as exc:
        print(f"SUBMIT TICKET ERROR: {exc}")
        if is_ajax:
            return jsonify({'status': 'error', 'message': 'Failed to submit ticket. Please try again.'}), 500
        flash('Failed to submit ticket. Please try again.', 'error')
        return redirect(url_for('submit_ticket_bp.submit_ticket_page'))
    finally:
        conn.close()
