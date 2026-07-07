# sidebar.py
from flask import session
from db import get_db_connection
import pymysql
import json
from functools import lru_cache

@lru_cache(maxsize=512)
def get_user_access(user_id):
    """
    Get access permissions from the users.permissions JSON column.
    Returns a dictionary like:
    {
        'dashboard': {'view': True, 'edit': True},
        'inventory': {'view': False, 'edit': False},
        ...
    }
    """

    # Default permissions (in case JSON is incomplete)
    default_access = {
        'dashboard': {'view': True, 'edit': False},
        'inventory': {'view': True, 'edit': False},
        'qrcode': {'view': True, 'edit': False},
        'report': {'view': True, 'edit': False},
        'manage_user': {'view': True, 'edit': False},
        'department': {'view': True, 'edit': False},
        'damage_report': {'view': True, 'edit': False},
        'receive_item': {'view': True, 'edit': False},
    }

    # guard: if no user_id provided, return defaults immediately
    if not user_id:
        return default_access

    conn = get_db_connection()
    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            cur.execute("SELECT permissions FROM users WHERE user_id = %s", (user_id,))
            row = cur.fetchone()

            if not row or not row.get("permissions"):
                return default_access

            try:
                # Parse JSON permissions
                permissions = json.loads(row["permissions"])
            except json.JSONDecodeError:
                print(f"⚠️ Invalid JSON in permissions for user {user_id}")
                return default_access

            # Merge with defaults to fill missing modules
            for key in default_access:
                if key not in permissions:
                    permissions[key] = default_access[key]
                else:
                    # Ensure both 'view' and 'edit' keys exist
                    permissions[key].setdefault('view', False)
                    permissions[key].setdefault('edit', False)

            return permissions

    except Exception as e:
        print(f"❌ Error fetching access for user {user_id}: {e}")
        return default_access
    finally:
        conn.close()
