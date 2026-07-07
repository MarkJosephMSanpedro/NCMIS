from db import get_db_connection
from datetime import date
import pymysql

def run_inventory_health_check():
    conn = get_db_connection()
    today = date.today()

    try:
        with conn.cursor() as cur:
            cur.execute("""
                UPDATE pcinfofull
                SET
                    health_score = GREATEST(
                        100 - (DATEDIFF(%s,
                            DATE_ADD(IFNULL(last_checked, date_acquired),
                            INTERVAL GREATEST(
                                1,
                                CASE
                                    WHEN IFNULL(maintenance_interval_days, 30) < 365
                                        THEN IFNULL(maintenance_interval_days, 30) * 365
                                    ELSE IFNULL(maintenance_interval_days, 30)
                                END
                            ) DAY)
                        ) * 2),
                        0
                    ),
                    risk_level = CASE
                        WHEN health_score >= 80 THEN 'Low'
                        WHEN health_score >= 50 THEN 'Medium'
                        ELSE 'High'
                    END,
                    status = CASE
                        WHEN health_score < 50 THEN 'Needs Checking'
                        ELSE status
                    END
            """, (today,))

        conn.commit()
        print("Inventory health analytics updated")

    except Exception as e:
        conn.rollback()
        print("Health check failed:", e)

    finally:
        conn.close()
