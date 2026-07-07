#!/usr/bin/env python3
"""Apply migration to add `role` column to `users` table if missing."""
from db import get_db_connection


def ensure_role_column():
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("SHOW COLUMNS FROM users")
            cols = {row['Field'] for row in cursor.fetchall()}
            if 'role' in cols:
                print("Column 'role' already exists.")
                return

            print("Adding 'role' column to users table...")
            cursor.execute("ALTER TABLE users ADD COLUMN role VARCHAR(50) DEFAULT 'staff' AFTER is_admin")
            print("Backfilling role for existing admin users...")
            cursor.execute("UPDATE users SET role = 'admin' WHERE is_admin = 1")
        conn.commit()
        print("Migration applied successfully.")
    except Exception as e:
        print("Migration failed:", e)
    finally:
        conn.close()


if __name__ == '__main__':
    ensure_role_column()
