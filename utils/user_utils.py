from db import get_db_connection
import pymysql


def get_faculty_name(user_id):

    conn = get_db_connection()

    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            cur.execute(
                "SELECT faculty_name FROM users WHERE user_id = %s",
                (user_id,)
            )
            row = cur.fetchone()

            if row:
                return row["faculty_name"]

            return None

    finally:
        conn.close()