import json
import pymysql
import os
import sys

# ensure project root is on sys.path so local modules (db.py) can be imported
ROOT = os.path.dirname(os.path.dirname(__file__))
if ROOT not in sys.path:
    sys.path.insert(0, ROOT)

from db import get_db_connection

conn = get_db_connection()
try:
    with conn.cursor(pymysql.cursors.DictCursor) as cursor:
        try:
            cursor.execute("SELECT user_id, first_name, last_name, faculty_name, username FROM users LIMIT 50")
            rows = cursor.fetchall() or []
            print(json.dumps(rows, default=str, ensure_ascii=False, indent=2))
        except Exception as e:
            print('ERROR', e)
finally:
    conn.close()
