import pymysql
from datetime import date, datetime, timedelta
from flask import Blueprint, render_template, request, session, redirect, url_for, jsonify

from db import get_db_connection
from utils.user_activity import ensure_user_activity_log_table, humanize_activity_action


activity_log_bp = Blueprint('activity_log_bp', __name__, template_folder='templates')


def _parse_activity_log_filters():
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 20, type=int)
    role_filter = (request.args.get('role', 'all') or 'all').lower()
    search = (request.args.get('search', '') or '').strip()
    log_date = (request.args.get('log_date', '') or '').strip()

    if page < 1:
        page = 1
    if per_page not in [10, 20, 50, 100]:
        per_page = 20
    if role_filter not in ['all', 'admin', 'staff']:
        role_filter = 'all'

    if log_date:
        try:
            date.fromisoformat(log_date)
        except ValueError:
            log_date = ''

    return page, per_page, role_filter, search, log_date


def _get_activity_log_data(page, per_page, role_filter, search, log_date):
    where_clauses = []
    params = []

    if role_filter != 'all':
        where_clauses.append('LOWER(role) = %s')
        params.append(role_filter)

    if search:
        where_clauses.append(
            '('
            'username LIKE %s OR '
            'action LIKE %s OR '
            'module LIKE %s OR '
            'details LIKE %s OR '
            'http_method LIKE %s OR '
            'route LIKE %s OR '
            'ip_address LIKE %s'
            ')'
        )
        search_like = f"%{search}%"
        params.extend([
            search_like,
            search_like,
            search_like,
            search_like,
            search_like,
            search_like,
            search_like,
        ])

    if log_date:
        selected_date = date.fromisoformat(log_date)
        day_start = datetime.combine(selected_date, datetime.min.time())
        next_day_start = day_start + timedelta(days=1)

        where_clauses.append('(created_at >= %s AND created_at < %s)')
        params.extend([day_start, next_day_start])

    where_sql = f"WHERE {' AND '.join(where_clauses)}" if where_clauses else ''

    conn = get_db_connection()
    try:
        ensure_user_activity_log_table(conn)

        with conn.cursor(pymysql.cursors.DictCursor) as cursor:
            cursor.execute(f"SELECT COUNT(*) AS total FROM user_activity_log {where_sql}", params)
            total_items = cursor.fetchone()['total']
            total_pages = (total_items + per_page - 1) // per_page if total_items else 1

            if page > total_pages:
                page = total_pages

            offset = (page - 1) * per_page

            query = f"""
                SELECT
                    log_id,
                    user_id,
                    username,
                    role,
                    action,
                    module,
                    details,
                    http_method,
                    route,
                    ip_address,
                    created_at
                FROM user_activity_log
                {where_sql}
                ORDER BY created_at DESC, log_id DESC
                LIMIT %s OFFSET %s
            """
            cursor.execute(query, params + [per_page, offset])
            logs = cursor.fetchall()

            cursor.execute(
                f"""
                SELECT role, COUNT(*) AS total
                FROM user_activity_log
                {where_sql}
                GROUP BY role
                """,
                params,
            )
            role_count_rows = cursor.fetchall()

        role_counts = {'Admin': 0, 'Staff': 0}
        for row in role_count_rows:
            role_name = row.get('role')
            if role_name in role_counts:
                role_counts[role_name] = row.get('total', 0)

        for log in logs:
            log['action'] = humanize_activity_action(
                log.get('action'),
                log.get('http_method'),
                log.get('route'),
            )
            if log.get('created_at') is not None:
                log['created_at'] = str(log['created_at'])

        return {
            'logs': logs,
            'page': page,
            'per_page': per_page,
            'total_items': total_items,
            'total_pages': total_pages,
            'role_filter': role_filter,
            'search': search,
            'log_date': log_date,
            'applied_filters': {
                'page': page,
                'per_page': per_page,
                'role': role_filter,
                'search': search,
                'log_date': log_date,
            },
            'admin_count': role_counts['Admin'],
            'staff_count': role_counts['Staff'],
        }
    finally:
        conn.close()


@activity_log_bp.route('/', strict_slashes=False)
def activity_log_page():
    if 'user' not in session or not session['user'].get('user_id'):
        return redirect(url_for('login_bp.login'))

    page, per_page, role_filter, search, log_date = _parse_activity_log_filters()
    data = _get_activity_log_data(page, per_page, role_filter, search, log_date)

    return render_template('activity_log.html', **data)


@activity_log_bp.route('/data')
def activity_log_data():
    if 'user' not in session or not session['user'].get('user_id'):
        return jsonify({'error': 'Unauthorized'}), 401

    page, per_page, role_filter, search, log_date = _parse_activity_log_filters()
    data = _get_activity_log_data(page, per_page, role_filter, search, log_date)

    return jsonify(data)
