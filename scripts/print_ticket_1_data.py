import os
import sys
import pymysql

# ensure project root is on sys.path so local modules (db.py) can be imported
ROOT = os.path.dirname(os.path.dirname(__file__))
if ROOT not in sys.path:
    sys.path.insert(0, ROOT)

from db import get_db_connection

TICKET_ID = 1
conn = get_db_connection()
try:
    with conn.cursor(pymysql.cursors.DictCursor) as cursor:
        # detect ticket_responses
        try:
            cursor.execute("SELECT COUNT(*) AS cnt FROM information_schema.TABLES WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'ticket_responses'")
            has_tr = bool(cursor.fetchone().get('cnt'))
        except Exception:
            has_tr = False

        # detect resolved_by/resolved_at columns
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

        if has_resolved_at and has_tr:
            resolved_expr = "COALESCE(t.resolved_at, (SELECT MAX(tr.created_at) FROM ticket_responses tr WHERE tr.ticket_id = t.ticket_id AND tr.action = 'resolve')) AS resolved_at"
        elif has_resolved_at and not has_tr:
            resolved_expr = "t.resolved_at AS resolved_at"
        elif has_tr and not has_resolved_at:
            resolved_expr = "(SELECT MAX(tr.created_at) FROM ticket_responses tr WHERE tr.ticket_id = t.ticket_id AND tr.action = 'resolve') AS resolved_at"
        else:
            resolved_expr = "NULL AS resolved_at"

        select_extra = ", t.resolved_by_id" if has_resolved_by else ""
        base_select = (
            "SELECT t.ticket_id, t.user_id, t.department_id, t.title, t.description, t.status, t.created_at, " + resolved_expr + ","
            " COALESCE(CONCAT_WS(' ', u.first_name, u.last_name), u.faculty_name, u.username) AS submitter_name, d.department_name AS facility_name, t.device_id" + select_extra + " "
            "FROM tickets t "
            "LEFT JOIN users u ON u.user_id = t.user_id "
            "LEFT JOIN departments d ON d.department_id = t.department_id "
        )

        cursor.execute(base_select + " WHERE t.ticket_id=%s", (TICKET_ID,))
        tickets = cursor.fetchall() or []
        print('Fetched tickets:', tickets)

        ticket_ids = [t['ticket_id'] for t in tickets]
        resolved_by_map = {}
        if ticket_ids and has_tr:
            placeholders = ','.join(['%s'] * len(ticket_ids))
            q = ("SELECT tr.ticket_id, tr.responder_id, tr.created_at, COALESCE(CONCAT_WS(' ', u.first_name, u.last_name), u.faculty_name, u.username) AS resolver_name "
                 "FROM ticket_responses tr LEFT JOIN users u ON u.user_id = tr.responder_id "
                 f"WHERE tr.ticket_id IN ({placeholders}) AND tr.action = 'resolve' ORDER BY tr.created_at DESC")
            cursor.execute(q, ticket_ids)
            resolve_rows = cursor.fetchall() or []
            print('Resolve rows from ticket_responses:', resolve_rows)
            for r in resolve_rows:
                tid = r['ticket_id']
                if tid not in resolved_by_map:
                    resolved_by_map[tid] = {
                        'responder_id': r.get('responder_id'),
                        'resolved_at': r.get('created_at'),
                        'resolver_name': r.get('resolver_name')
                    }

        # If tickets table has resolved_by_id, fetch names
        if has_resolved_by:
            ticket_resolver_map = {t['ticket_id']: t.get('resolved_by_id') for t in tickets if t.get('resolved_by_id')}
            resolver_ids = sorted({v for v in ticket_resolver_map.values() if v})
            if resolver_ids:
                placeholders_u = ','.join(['%s'] * len(resolver_ids))
                cursor.execute(f"SELECT user_id, CONCAT_WS(' ', first_name, last_name) AS name, faculty_name, username FROM users WHERE user_id IN ({placeholders_u})", resolver_ids)
                users = {u['user_id']: (u.get('name') or u.get('faculty_name') or u.get('username')) for u in (cursor.fetchall() or [])}
                for tid, rid in ticket_resolver_map.items():
                    if tid not in resolved_by_map and rid:
                        resolved_by_map[tid] = {'responder_id': rid, 'resolver_name': users.get(rid) or None, 'resolved_at': next((tt.get('resolved_at') for tt in tickets if tt.get('ticket_id')==tid), None)}

        print('Resolved_by_map:', resolved_by_map)

        # Build final ticket dict as template would see
        final = []
        for t in tickets:
            tid = t.get('ticket_id')
            rb = resolved_by_map.get(tid)
            t['resolved_by'] = rb.get('resolver_name') if rb else None
            t['resolved_by_id'] = rb.get('responder_id') if rb else None
            if rb and rb.get('resolved_at'):
                t['resolved_at'] = rb.get('resolved_at')
            final.append(t)
        print('Final ticket data:', final)
finally:
    conn.close()
