#!/usr/bin/env python3
"""Create a test user in the application's database.

Usage:
  python scripts/add_test_user.py --username testuser --email test@example.com --password Test@1234

This uses the same DB config as the app (via `db.get_db_connection`).
"""
import argparse
import json
import sys

from werkzeug.security import generate_password_hash
from db import get_db_connection


def create_test_user(username, email, password, is_admin, first_name, middle_name, last_name, role='staff'):
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            # check for existing username/email
            cursor.execute("SELECT user_id FROM users WHERE username=%s OR email=%s LIMIT 1", (username, email))
            if cursor.fetchone():
                print(f"User with username '{username}' or email '{email}' already exists.")
                return False

            permissions = {
                "dashboard": {"view": True, "edit": False},
                "inventory": {"view": True, "edit": False},
                "transaction": {"view": True, "add": True, "edit": False},
                "submit_ticket": {"view": True, "add": True},
                "qrlist": {"view": True, "edit": False},
                "report": {"view": True, "edit": False},
                "dept": {"view": True, "edit": False, "delete": False},
                "damage_report": {"view": False, "edit": False},
                "receive_item": {"view": False, "edit": False},
                "activity_log": {"view": False, "edit": False},
                "manage_user": {"view": False, "edit": False},
                "maintenance": {"view": False, "edit": False},
                "stock_room": {"view": False, "edit": False}
            }

            hashed_pw = generate_password_hash(password)

            sql = """
                INSERT INTO users 
                (first_name, middle_name, last_name, username, email, password, is_admin, role, permissions, is_active, created_at, updated_at)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, 1, NOW(), NOW())
            """
            cursor.execute(sql, (
                first_name, middle_name, last_name,
                username, email, hashed_pw, int(is_admin), role, json.dumps(permissions)
            ))
        conn.commit()
        print(f"Created user '{username}' with email '{email}'.")
        return True
    except Exception as exc:
        print("Error creating test user:", exc)
        return False
    finally:
        conn.close()


def main():
    parser = argparse.ArgumentParser(description="Create a test user for the app database")
    parser.add_argument('-u', '--username', default='testuser')
    parser.add_argument('-e', '--email', default='test@example.com')
    parser.add_argument('-p', '--password', default='Test@1234')
    parser.add_argument('-a', '--admin', action='store_true', help='Create as admin')
    parser.add_argument('--role', default=None, help='Role string (staff, technician, dept_head, admin)')
    parser.add_argument('--first', default='Test')
    parser.add_argument('--middle', default='')
    parser.add_argument('--last', default='User')

    args = parser.parse_args()

    role_arg = args.role if args.role else ('admin' if args.admin else 'staff')
    ok = create_test_user(
        username=args.username,
        email=args.email,
        password=args.password,
        is_admin=1 if args.admin else 0,
        first_name=args.first,
        middle_name=args.middle,
        last_name=args.last,
        role=role_arg,
    )

    if not ok:
        sys.exit(1)


if __name__ == '__main__':
    main()
