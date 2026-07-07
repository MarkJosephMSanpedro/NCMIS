from db import get_db_connection
from flask import request


CREATE_USER_ACTIVITY_LOG_TABLE_SQL = """
CREATE TABLE IF NOT EXISTS user_activity_log (
    log_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id INT UNSIGNED NULL,
    username VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL,
    action VARCHAR(120) NOT NULL,
    module VARCHAR(120) DEFAULT NULL,
    details TEXT DEFAULT NULL,
    http_method VARCHAR(10) DEFAULT NULL,
    route VARCHAR(255) DEFAULT NULL,
    ip_address VARCHAR(45) DEFAULT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (log_id),
    KEY idx_user_activity_created_at (created_at),
    KEY idx_user_activity_role (role),
    KEY idx_user_activity_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
"""


EXPECTED_ACTIVITY_LOG_COLUMNS = {
    'user_id': "ADD COLUMN user_id INT UNSIGNED NULL AFTER log_id",
    'username': "ADD COLUMN username VARCHAR(100) NOT NULL DEFAULT '' AFTER user_id",
    'role': "ADD COLUMN role VARCHAR(20) NOT NULL DEFAULT 'Staff' AFTER username",
    'action': "ADD COLUMN action VARCHAR(120) NOT NULL DEFAULT 'Activity' AFTER role",
    'module': "ADD COLUMN module VARCHAR(120) DEFAULT NULL AFTER action",
    'details': "ADD COLUMN details TEXT DEFAULT NULL AFTER module",
    'http_method': "ADD COLUMN http_method VARCHAR(10) DEFAULT NULL AFTER details",
    'route': "ADD COLUMN route VARCHAR(255) DEFAULT NULL AFTER http_method",
    'ip_address': "ADD COLUMN ip_address VARCHAR(45) DEFAULT NULL AFTER route",
    'created_at': "ADD COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP AFTER ip_address",
}


EXPECTED_ACTIVITY_LOG_INDEXES = {
    'idx_user_activity_created_at': "ADD KEY idx_user_activity_created_at (created_at)",
    'idx_user_activity_role': "ADD KEY idx_user_activity_role (role)",
    'idx_user_activity_user_id': "ADD KEY idx_user_activity_user_id (user_id)",
}


def _sync_user_activity_log_schema(conn):
    """Backfill missing columns/indexes when an older activity table already exists."""
    with conn.cursor() as cursor:
        cursor.execute("SHOW COLUMNS FROM user_activity_log")
        existing_columns = {row['Field'] for row in cursor.fetchall()}

        for column_name, alter_sql in EXPECTED_ACTIVITY_LOG_COLUMNS.items():
            if column_name not in existing_columns:
                cursor.execute(f"ALTER TABLE user_activity_log {alter_sql}")

        cursor.execute("SHOW INDEX FROM user_activity_log")
        existing_indexes = {row['Key_name'] for row in cursor.fetchall()}

        for index_name, alter_sql in EXPECTED_ACTIVITY_LOG_INDEXES.items():
            if index_name not in existing_indexes:
                cursor.execute(f"ALTER TABLE user_activity_log {alter_sql}")


def humanize_activity_action(action, http_method=None, route=None):
    """Return a readable activity label based on stored action and route metadata."""
    raw_action = (action or '').strip()
    raw_method = (http_method or '').strip().upper()
    raw_route = (route or '').strip().lower()

    generic_actions = {
        'POST Request',
        'GET Request',
        'PUT Request',
        'PATCH Request',
        'DELETE Request',
        'Submit',
    }

    if raw_action and raw_action not in generic_actions:
        return raw_action

    if 'run-risk-update' in raw_route or 'run-device-risk-update' in raw_route:
        return 'Update Risk Levels'
    if 'bulk-check' in raw_route:
        return 'Mark Selected as Checked'
    if raw_route.endswith('/check'):
        return 'Mark as Checked'
    if 'bulk-surrender' in raw_route:
        return 'Surrender Selected'
    if 'bulk-damaged' in raw_route or 'device-bulk-damaged' in raw_route:
        return 'Mark Selected as Damaged'
    if 'import' in raw_route:
        return 'Import File'
    if 'export' in raw_route:
        return 'Export File'
    if 'filter' in raw_route:
        return 'Filter'
    if '/add-' in raw_route or raw_route.endswith('/add'):
        return 'Add Item'
    if '/update-' in raw_route or 'bulk-update' in raw_route:
        return 'Edit Item'
    if '/delete-' in raw_route or '/delete/' in raw_route:
        return 'Delete Item'

    if raw_method == 'GET':
        return 'Filter'
    if raw_method in {'POST', 'PUT', 'PATCH'}:
        return 'Submit'
    if raw_method == 'DELETE':
        return 'Delete Item'

    if raw_action in generic_actions:
        if raw_action.startswith('GET'):
            return 'Filter'
        if raw_action.startswith('DELETE'):
            return 'Delete Item'
        return 'Submit'

    return raw_action or 'Activity'


def ensure_user_activity_log_table(conn=None):
    """Create the activity log table if it does not exist yet."""
    created_local_conn = False

    if conn is None:
        conn = get_db_connection()
        created_local_conn = True

    try:
        with conn.cursor() as cursor:
            cursor.execute(CREATE_USER_ACTIVITY_LOG_TABLE_SQL)
        _sync_user_activity_log_schema(conn)
        conn.commit()
    finally:
        if created_local_conn:
            conn.close()


def log_user_activity(*, user, action, module=None, details=None):
    """Persist an activity log row for the authenticated admin/staff user."""
    if not user or not action:
        return

    username = (user.get('username') or '').strip()
    if not username:
        return

    # Prefer explicit role string when available, else fallback to is_admin
    raw_role = (user.get('role') or '').strip()
    if raw_role:
        role = raw_role.replace('_', ' ').title()
    else:
        role = 'Admin' if bool(user.get('is_admin')) else 'Staff'

    conn = get_db_connection()
    try:
        ensure_user_activity_log_table(conn)

        with conn.cursor() as cursor:
            cursor.execute(
                """
                INSERT INTO user_activity_log (
                    user_id,
                    username,
                    role,
                    action,
                    module,
                    details,
                    http_method,
                    route,
                    ip_address
                ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
                """,
                (
                    user.get('user_id'),
                    username,
                    role,
                    action,
                    module,
                    details,
                    request.method if request else None,
                    request.path if request else None,
                    request.remote_addr if request else None,
                ),
            )

        conn.commit()
    except Exception as exc:
        conn.rollback()
        print(f"USER ACTIVITY LOG ERROR: {exc}")
    finally:
        conn.close()
