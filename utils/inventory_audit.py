from db import get_db_connection
from datetime import datetime
import pymysql

def log_inventory_action(
    entity_type,
    entity_id,
    action,
    field_name=None,
    old_value=None,
    new_value=None,
    performed_by=None
):
    """
    Logs inventory actions safely.
    Supports CREATE, UPDATE, DELETE, BULK actions.
    """

    conn = get_db_connection()
    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            cur.execute("""
                INSERT INTO inventory_audit_log (
                    entity_type,
                    entity_id,
                    action,
                    field_name,
                    old_value,
                    new_value,
                    performed_by,
                    performed_at
                ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
            """, (
                entity_type,
                entity_id,
                action,
                field_name,
                str(old_value) if old_value is not None else None,
                str(new_value) if new_value is not None else None,
                performed_by,
                datetime.now()
            ))

        conn.commit()
    except Exception as e:
        conn.rollback()
        print(f"❌ AUDIT LOG ERROR: {e}")
    finally:
        conn.close()
