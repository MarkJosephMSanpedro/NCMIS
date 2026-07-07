import os
import sys
import pymysql

# ensure project root is on sys.path so local modules (db.py) can be imported
ROOT = os.path.dirname(os.path.dirname(__file__))
if ROOT not in sys.path:
    sys.path.insert(0, ROOT)

from db import get_db_connection

TICKET_ID = 1
RESPONDER_ID = 9

conn = get_db_connection()
try:
    with conn.cursor(pymysql.cursors.DictCursor) as cursor:
        try:
            # Update tickets table if columns exist (check both resolved_at and resolved_by_id)
            try:
                cursor.execute("SELECT COUNT(*) AS cnt FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'tickets' AND COLUMN_NAME = 'resolved_at'")
                has_resolved_at = bool(cursor.fetchone().get('cnt'))
            except Exception:
                has_resolved_at = False
            try:
                cursor.execute("SELECT COUNT(*) AS cnt FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'tickets' AND COLUMN_NAME = 'resolved_by_id'")
                has_resolved_by = bool(cursor.fetchone().get('cnt'))
            except Exception:
                has_resolved_by = False

            if has_resolved_at and has_resolved_by:
                cursor.execute("UPDATE tickets SET status=%s, resolved_at=NOW(), resolved_by_id=%s WHERE ticket_id=%s", ('Resolved', RESPONDER_ID, TICKET_ID))
            elif has_resolved_by and not has_resolved_at:
                cursor.execute("UPDATE tickets SET status=%s, resolved_by_id=%s WHERE ticket_id=%s", ('Resolved', RESPONDER_ID, TICKET_ID))
            elif has_resolved_at and not has_resolved_by:
                cursor.execute("UPDATE tickets SET status=%s, resolved_at=NOW() WHERE ticket_id=%s", ('Resolved', TICKET_ID))
            else:
                cursor.execute("UPDATE tickets SET status=%s WHERE ticket_id=%s", ('Resolved', TICKET_ID))
            conn.commit()

            # Insert a ticket_responses row
            try:
                cursor.execute("INSERT INTO ticket_responses (ticket_id, responder_id, action, feedback) VALUES (%s, %s, %s, %s)", (TICKET_ID, RESPONDER_ID, 'resolve', 'Test: marked resolved by assistant'))
                conn.commit()
            except Exception as e:
                print('Could not insert ticket_responses row:', e)

            # Show resulting ticket row (only request columns that exist)
            cols = ['ticket_id', 'status']
            if has_resolved_at:
                cols.append('resolved_at')
            if has_resolved_by:
                cols.append('resolved_by_id')
            col_sql = ', '.join(cols)
            cursor.execute(f"SELECT {col_sql} FROM tickets WHERE ticket_id=%s", (TICKET_ID,))
            print('Ticket after update:', cursor.fetchone())

            # Show resolve responses for this ticket
            cursor.execute("SELECT id, ticket_id, responder_id, action, created_at, feedback FROM ticket_responses WHERE ticket_id=%s ORDER BY created_at DESC LIMIT 10", (TICKET_ID,))
            rows = cursor.fetchall() or []
            print('Recent responses for ticket:', rows)

        except Exception as e:
            print('ERROR performing updates:', e)
finally:
    conn.close()
