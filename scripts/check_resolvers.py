import os
import sys
import pymysql

# ensure project root is on sys.path so local modules (db.py) can be imported
ROOT = os.path.dirname(os.path.dirname(__file__))
if ROOT not in sys.path:
    sys.path.insert(0, ROOT)

from db import get_db_connection

conn = get_db_connection()
try:
    with conn.cursor(pymysql.cursors.DictCursor) as cursor:
        # quick info: check if ticket_responses exists
        try:
            cursor.execute("SELECT COUNT(*) AS cnt FROM information_schema.TABLES WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'ticket_responses'")
            tr_exists = bool(cursor.fetchone().get('cnt'))
            print('ticket_responses exists:', tr_exists)
        except Exception as e:
            print('Could not check ticket_responses existence:', e)
        print('Recent resolve responses (ticket_id, responder_id, resolver_name, created_at):')
        try:
            cursor.execute("SELECT tr.ticket_id, tr.responder_id, tr.created_at, CONCAT_WS(' ', u.first_name, u.last_name) AS resolver_name, u.faculty_name, u.username FROM ticket_responses tr LEFT JOIN users u ON u.user_id = tr.responder_id WHERE tr.action='resolve' ORDER BY tr.created_at DESC LIMIT 50")
            rows = cursor.fetchall() or []
            for r in rows:
                print(r)
        except Exception as e:
            print('Could not query ticket_responses:', e)

            print('\nAll ticket_responses (recent):')
            try:
                cursor.execute("SELECT tr.id, tr.ticket_id, tr.responder_id, tr.action, tr.created_at, CONCAT_WS(' ', u.first_name, u.last_name) AS resolver_name, u.faculty_name, u.username FROM ticket_responses tr LEFT JOIN users u ON u.user_id = tr.responder_id ORDER BY tr.created_at DESC LIMIT 200")
                all_rows = cursor.fetchall() or []
                for r in all_rows:
                    print(r)
            except Exception as e:
                print('Could not fetch all responses:', e)

            print('\nTicket_responses table definition:')
            try:
                cursor.execute("SHOW CREATE TABLE ticket_responses")
                crt = cursor.fetchone()
                print(crt)
            except Exception as e:
                print('Could not show ticket_responses definition:', e)

        print('\nRecently resolved tickets (ticket_id, status, resolved_at, resolved_by candidate):')
        try:
            cursor.execute("SELECT t.ticket_id, t.status, (SELECT MAX(tr.created_at) FROM ticket_responses tr WHERE tr.ticket_id=t.ticket_id AND tr.action='resolve') AS resolved_at, CONCAT_WS(' ', u.first_name, u.last_name) AS submitter_name, u.faculty_name, u.username FROM tickets t LEFT JOIN users u ON u.user_id=t.user_id WHERE LOWER(t.status) IN ('resolved','closed') ORDER BY t.created_at DESC LIMIT 50")
            rows2 = cursor.fetchall() or []
            for r in rows2:
                print(r)
        except Exception as e:
            print('Could not query tickets:', e)
finally:
    conn.close()