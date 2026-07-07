from flask import Blueprint, render_template, request, redirect, url_for, flash, session
import os
import pymysql
from datetime import datetime
from db import get_db_connection
from utils.user_activity import log_user_activity
from utils.status_utils import normalize_db_status, normalize_status_key

concern_bp = Blueprint('concern_bp', __name__, template_folder='templates')


@concern_bp.route('/add-concern', methods=['GET', 'POST'])
def add_concern():
    user = session.get('user')
    if not user:
        return redirect(url_for('login_bp.login'))

    # ensure CSRF token in session
    if 'csrf_token' not in session:
        session['csrf_token'] = os.urandom(32).hex()
    token = session['csrf_token']

    if request.method == 'POST':
        form_token = request.form.get('csrf_token', '')
        if not form_token or form_token != token:
            flash('Invalid form submission', 'error')
            return redirect(url_for('concern_bp.add_concern'))

        description = (request.form.get('description') or '').strip()
        device_ids = request.form.getlist('devices')

        # Validation
        if not description:
            flash('Please describe your concern', 'error')
            return redirect(url_for('concern_bp.add_concern'))
        if len(description) < 10:
            flash('Description must be at least 10 characters long', 'error')
            return redirect(url_for('concern_bp.add_concern'))
        if not device_ids:
            flash('Please select at least one device', 'error')
            return redirect(url_for('concern_bp.add_concern'))

        conn = get_db_connection()
        try:
            with conn.cursor() as cursor:
                # ensure tables exist
                cursor.execute(
                    """
                    CREATE TABLE IF NOT EXISTS concerns (
                        concern_id INT AUTO_INCREMENT PRIMARY KEY,
                        user_id INT,
                        description TEXT,
                        status VARCHAR(50) DEFAULT 'Pending',
                        created_at DATETIME DEFAULT NOW()
                    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
                    """
                )

                cursor.execute(
                    """
                    CREATE TABLE IF NOT EXISTS concern_devices (
                        id INT AUTO_INCREMENT PRIMARY KEY,
                        concern_id INT,
                        device_id INT
                    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
                    """
                )

                # Insert concern
                cursor.execute(
                    "INSERT INTO concerns (user_id, description, status, created_at) VALUES (%s, %s, %s, NOW())",
                    (user.get('user_id'), description, normalize_db_status('Pending'))
                )
                concern_id = cursor.lastrowid

                # Insert device associations
                insert_stmt = "INSERT INTO concern_devices (concern_id, device_id) VALUES (%s, %s)"
                for did in device_ids:
                    try:
                        did_int = int(did)
                    except Exception:
                        continue
                    if did_int > 0:
                        cursor.execute(insert_stmt, (concern_id, did_int))

            conn.commit()
            flash(f'Concern submitted successfully! Ticket #{concern_id} has been created.', 'success')
            log_user_activity(user=user, action='Submit Concern', module='Concerns', details=f'Concern #{concern_id} submitted')
            return redirect(url_for('concern_bp.concern_list'))
        except Exception as exc:
            try:
                conn.rollback()
            except Exception:
                pass
            flash(f'Error submitting concern: {exc}', 'error')
            return redirect(url_for('concern_bp.add_concern'))
        finally:
            conn.close()

    # GET: fetch facilities and devices
    conn = get_db_connection()
    facilities = {}
    try:
        try:
            with conn.cursor(pymysql.cursors.DictCursor) as cursor:
                cursor.execute(
                    """
                    SELECT f.facility_id, f.facility_name,
                           d.device_id, d.device_name
                    FROM facilities f
                    LEFT JOIN devices d ON f.facility_id = d.facility_id
                    ORDER BY f.facility_name, d.device_name
                    """
                )
                rows = cursor.fetchall()

            for row in rows:
                fid = row.get('facility_id')
                if fid not in facilities:
                    facilities[fid] = {'facility_name': row.get('facility_name'), 'devices': []}
                if row.get('device_id'):
                    facilities[fid]['devices'].append({'device_id': row.get('device_id'), 'device_name': row.get('device_name')})
        except Exception as e:
            # If facilities/devices tables are not present, continue with empty list
            facilities = {}
            flash('Facilities/devices are not configured in the database.', 'error')
    finally:
        conn.close()

    return render_template('add_concern.html', facilities=facilities, csrf_token=token)


@concern_bp.route('/concern-list')
def concern_list():
    user = session.get('user')
    if not user:
        return redirect(url_for('login_bp.login'))

    # Determine whether the current user should see all tickets.
    # Previously this used only `is_admin`; allow users with the
    # `submit_ticket.view` permission to also view the full queue.
    perms = user.get('permissions') or {}
    if isinstance(perms, str):
        try:
            import json
            perms = json.loads(perms)
        except Exception:
            perms = {}
    can_view_all = bool(user.get('is_admin')) or bool(perms.get('submit_ticket', {}).get('view'))

    conn = get_db_connection()
    concerns = []
    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cursor:
            # Try to load from tickets (newer submit-ticket flow) and map to a common shape
            try:
                # If the current user is an admin, include all tickets so admins
                # can view the same items they see in the admin queue. Regular
                # users only see their own tickets. Also include the submitting
                # user's role when available so the UI can color-code by role.
                if can_view_all:
                    cursor.execute(
                        """
                        SELECT t.ticket_id AS concern_id,
                               t.title,
                               t.description,
                               t.status,
                               t.created_at,
                               u.role AS user_role
                        FROM tickets t
                        LEFT JOIN users u ON t.user_id = u.user_id
                        """
                    )
                else:
                    cursor.execute(
                        """
                        SELECT t.ticket_id AS concern_id,
                               t.title,
                               t.description,
                               t.status,
                               t.created_at,
                               u.role AS user_role
                        FROM tickets t
                        LEFT JOIN users u ON t.user_id = u.user_id
                        WHERE t.user_id=%s
                        """,
                        (user.get('user_id'),)
                    )
                tickets = cursor.fetchall() or []
                for t in tickets:
                    # Combine title and description for display
                    title = (t.get('title') or '').strip()
                    desc = (t.get('description') or '').strip()
                    combined = (title + '\n\n' + desc).strip() if title else desc
                    concerns.append({
                        'concern_id': t.get('concern_id'),
                        'description': combined,
                        'status': t.get('status'),
                        'created_at': t.get('created_at'),
                        'user_role': (t.get('user_role') or '')
                    })
            except Exception:
                # Tickets table might not exist; ignore and continue to legacy concerns
                pass

            # Also include legacy "concerns" records so both sources are visible
            try:
                if can_view_all:
                    cursor.execute(
                        "SELECT c.concern_id, c.description, c.status, c.created_at, u.role AS user_role "
                        "FROM concerns c LEFT JOIN users u ON c.user_id = u.user_id"
                    )
                else:
                    cursor.execute(
                        "SELECT c.concern_id, c.description, c.status, c.created_at, u.role AS user_role "
                        "FROM concerns c LEFT JOIN users u ON c.user_id = u.user_id WHERE c.user_id=%s",
                        (user.get('user_id'),)
                    )
                legacy = cursor.fetchall() or []
                for c in legacy:
                    # Ensure a consistent key exists for templates
                    if 'user_role' not in c:
                        c['user_role'] = ''
                    concerns.append(c)
            except Exception:
                # If concerns table doesn't exist, continue
                pass
    finally:
        conn.close()

    # Normalize and sort by created_at desc
    def _ts(val):
        v = val.get('created_at')
        if isinstance(v, datetime):
            return v
        try:
            return datetime.fromisoformat(str(v))
        except Exception:
            return datetime.min

    concerns.sort(key=_ts, reverse=True)

    # Optional `?status=` query param only controls the initial active filter
    # state in the UI. We no longer pre-filter results on the server so the
    # client-side script can show/hide items and compute accurate counts from
    # the DOM (avoids mismatches between server counts and client-visible
    # items when users interact with the page).
    status_filter = (request.args.get('status') or 'all').strip().lower()
    if status_filter in ('inprogress', 'in-progress'):
        status_filter = 'ongoing'
    if not status_filter:
        status_filter = 'all'

    return render_template('concern_list.html', concerns=concerns, active_filter=status_filter)
