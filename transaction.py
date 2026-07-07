from flask import Blueprint, jsonify, request, render_template, send_file,session, make_response, redirect, url_for
import pymysql
from db import get_db_connection
from io import BytesIO
import pandas as pd
from utils.permissions import check_permission
import time
import random

transaction_bp = Blueprint('transaction_bp', __name__, template_folder='templates')


@transaction_bp.route('/transactions')
@check_permission('transaction', 'view')
def transaction_page():
    """Render the transaction page for receive/return operations."""
    current_user_id = None
    current_username = ""
    selectable_users = []

    try:
        current_session_user = session.get('user') or {}
        current_user_id = _safe_int(current_session_user.get('user_id'))
        current_username = str(current_session_user.get('username') or '').strip()
    except Exception:
        current_user_id = None
        current_username = ""

    try:
        conn = get_db_connection()
        try:
            with conn.cursor(pymysql.cursors.DictCursor) as cursor:
                selectable_users = _fetch_selectable_users(cursor)
        finally:
            conn.close()
    except Exception as e:
        print(f"❌ Error preloading transaction users: {e}")
        selectable_users = []

    if current_user_id and current_username:
        current_exists = any(_safe_int(user.get('user_id')) == current_user_id for user in selectable_users)
        if not current_exists:
            selectable_users.insert(0, {
                'user_id': current_user_id,
                'username': current_username,
            })

    response = make_response(render_template(
        'transaction.html',
        current_user_id=current_user_id,
        preloaded_users=selectable_users,
    ))
    response.headers['Cache-Control'] = 'no-store, no-cache, must-revalidate, max-age=0'
    response.headers['Pragma'] = 'no-cache'
    return response


@transaction_bp.route('/transaction_history')
@check_permission('transaction', 'view')
def transaction_history_page():
    """Render the transaction history page for viewing all transactions."""
    return render_template('transaction_history.html')



@transaction_bp.route('/get-departments')
def get_departments():
    """Fetch all departments for dropdown selection."""
    conn = get_db_connection()
    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cursor:
            cursor.execute("SELECT department_id, department_name FROM departments ORDER BY department_name")
            results = cursor.fetchall()
        return jsonify(results)
    except Exception as e:
        print(f"❌ Error fetching departments: {e}")
        return jsonify([]), 500
    finally:
        conn.close()


def _safe_int(value):
    try:
        if value is None:
            return None
        return int(str(value).strip())
    except (TypeError, ValueError):
        return None


def _normalize_item_name(value):
    name = (value or "").strip()
    if name.lower().endswith("(new item)"):
        name = name[:-10].strip()
    return name


def _safe_positive_float(value):
    if value in (None, ""):
        return None
    try:
        parsed = float(value)
    except (TypeError, ValueError):
        return None
    return parsed if parsed >= 0 else None


def _fetch_selectable_users(cursor):
    cursor.execute(
        """
        SELECT
            user_id,
            NULLIF(TRIM(username), '') AS username,
            COALESCE(
                NULLIF(
                    TRIM(CONCAT_WS(' ',
                        NULLIF(TRIM(first_name), ''),
                        NULLIF(TRIM(middle_name), ''),
                        NULLIF(TRIM(last_name), '')
                    )),
                    ''
                ),
                NULLIF(TRIM(faculty_name), ''),
                NULLIF(TRIM(username), '')
            ) AS display_name
        FROM users
        WHERE is_active = 1
          AND COALESCE(
                NULLIF(
                    TRIM(CONCAT_WS(' ',
                        NULLIF(TRIM(first_name), ''),
                        NULLIF(TRIM(middle_name), ''),
                        NULLIF(TRIM(last_name), '')
                    )),
                    ''
                ),
                NULLIF(TRIM(faculty_name), ''),
                NULLIF(TRIM(username), '')
              ) IS NOT NULL
        ORDER BY COALESCE(
            NULLIF(
                TRIM(CONCAT_WS(' ',
                    NULLIF(TRIM(first_name), ''),
                    NULLIF(TRIM(middle_name), ''),
                    NULLIF(TRIM(last_name), '')
                )),
                ''
            ),
            NULLIF(TRIM(faculty_name), ''),
            NULLIF(TRIM(username), '')
        )
        """
    )
    users = cursor.fetchall() or []

    if users:
        return users

    # Fallback: return username-bearing users even if not marked active.
    cursor.execute(
        """
        SELECT
            user_id,
            NULLIF(TRIM(username), '') AS username,
            COALESCE(
                NULLIF(
                    TRIM(CONCAT_WS(' ',
                        NULLIF(TRIM(first_name), ''),
                        NULLIF(TRIM(middle_name), ''),
                        NULLIF(TRIM(last_name), '')
                    )),
                    ''
                ),
                NULLIF(TRIM(faculty_name), ''),
                NULLIF(TRIM(username), '')
            ) AS display_name
        FROM users
        WHERE COALESCE(
                NULLIF(
                    TRIM(CONCAT_WS(' ',
                        NULLIF(TRIM(first_name), ''),
                        NULLIF(TRIM(middle_name), ''),
                        NULLIF(TRIM(last_name), '')
                    )),
                    ''
                ),
                NULLIF(TRIM(faculty_name), ''),
                NULLIF(TRIM(username), '')
              ) IS NOT NULL
        ORDER BY COALESCE(
            NULLIF(
                TRIM(CONCAT_WS(' ',
                    NULLIF(TRIM(first_name), ''),
                    NULLIF(TRIM(middle_name), ''),
                    NULLIF(TRIM(last_name), '')
                )),
                ''
            ),
            NULLIF(TRIM(faculty_name), ''),
            NULLIF(TRIM(username), '')
        )
        """
    )
    return cursor.fetchall() or []


_PC_PART_DEVICE_TYPE_KEYWORDS = {
    "motherboard": "Motherboard",
    "ram": "RAM",
    "storage": "Storage",
    "ssd": "Storage",
    "hdd": "Storage",
    "gpu": "GPU",
    "graphics": "GPU",
    "video card": "GPU",
    "psu": "PSU",
    "power supply": "PSU",
    "casing": "Casing",
    "case": "Casing",
    "cpu": "CPU",
    "processor": "CPU",
    "cpu cooler": "CPU Cooler",
    "case fan": "Case Fan",
}


def _resolve_device_type(item_name, requested_type=None):
    normalized_requested = _normalize_item_name(requested_type)
    if normalized_requested and normalized_requested.lower() != "consumable":
        return normalized_requested

    normalized_item = _normalize_item_name(item_name).lower()
    for keyword, resolved_type in _PC_PART_DEVICE_TYPE_KEYWORDS.items():
        if keyword in normalized_item:
            return resolved_type

    return "Consumable"


def _generate_unique_serial(prefix="SN"):
    return f"{prefix}{int(time.time()*1000) % 1000000}{random.randint(10,99)}"


def _generate_unique_serial_pair(cursor):
    serial_no = _generate_unique_serial("SN")
    municipal_serial_no = _generate_unique_serial("MSN")

    while True:
        cursor.execute(
            """
            SELECT COUNT(*) AS count
            FROM devices_full
            WHERE serial_no=%s OR municipal_serial_no=%s
            """,
            (serial_no, municipal_serial_no),
        )
        row = cursor.fetchone() or {}
        if (row.get("count") or 0) == 0:
            return serial_no, municipal_serial_no

        serial_no = _generate_unique_serial("SN")
        municipal_serial_no = _generate_unique_serial("MSN")


def _ensure_consumables_row(cursor, accession_id, item_name, quantity):
    cursor.execute(
        """
        INSERT INTO consumables (accession_id, item_name, quantity, status)
        VALUES (%s, %s, %s, %s)
        ON DUPLICATE KEY UPDATE
            item_name = VALUES(item_name),
            quantity = VALUES(quantity)
        """,
        (accession_id, item_name, quantity, 'Available'),
    )


def _ensure_consumable_usage_table(cursor):
    """Create the `consumable_usage` table if it does not exist.

    Many parts of the app read from this table; ensure it exists to avoid
    operational errors on queries when it hasn't yet been created.
    """
    try:
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS consumable_usage (
                id INT AUTO_INCREMENT PRIMARY KEY,
                accession_id INT NOT NULL,
                item_name VARCHAR(255) DEFAULT NULL,
                quantity INT NOT NULL,
                previous_stock INT DEFAULT NULL,
                new_stock INT DEFAULT NULL,
                reference_no VARCHAR(100) DEFAULT NULL,
                reason VARCHAR(255) DEFAULT NULL,
                notes TEXT DEFAULT NULL,
                performed_by INT DEFAULT NULL,
                department_id INT DEFAULT NULL,
                created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
        """)
    except Exception:
        # If creation fails (permissions/schema), ignore and let callers
        # handle missing-table errors gracefully.
        pass


def _bootstrap_device_from_consumables(
    cursor,
    accession_id,
    item_name,
    quantity,
    device_type="Consumable",
    brand_model=None,
    date_acquired=None,
    accountable=None,
    department_id=None,
    cost=None,
):
    serial_no, municipal_serial_no = _generate_unique_serial_pair(cursor)

    cursor.execute(
        """
        INSERT INTO devices_full
        (accession_id, item_name, brand_model, date_acquired, accountable, serial_no, municipal_serial_no, quantity, device_type, status, department_id, acquisition_cost)
        VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
        """,
        (
            accession_id,
            item_name,
            brand_model,
            date_acquired,
            accountable,
            serial_no,
            municipal_serial_no,
            quantity,
            device_type,
            "Available",
            department_id,
            cost,
        ),
    )


def _normalize_device_row_for_inventory_views(cursor, accession_id, item_name):
    cursor.execute(
        """
        UPDATE devices_full
        SET
            item_name = COALESCE(NULLIF(%s, ''), item_name),
            device_type = CASE
                WHEN device_type IS NULL
                  OR TRIM(device_type) = ''
                  OR TRIM(device_type) REGEXP '^[0-9]+$'
                THEN 'Consumable'
                ELSE device_type
            END,
            status = CASE
                WHEN status IS NULL OR TRIM(status) = ''
                THEN 'Available'
                ELSE status
            END
        WHERE accession_id = %s
        """,
        (item_name, accession_id),
    )

@transaction_bp.route('/consumables/api', methods=['GET'])
@check_permission('transaction', 'view')
def get_consumables():

    conn = get_db_connection()
    cursor = conn.cursor(pymysql.cursors.DictCursor)

    try:
        cursor.execute(
            """
            SELECT
                c.accession_id,
                COALESCE(df.item_name, c.item_name) AS item_name,
                COALESCE(df.quantity, c.quantity) AS quantity,
                'Consumable' AS device_type
            FROM consumables c
            LEFT JOIN devices_full df
                ON df.accession_id = c.accession_id

            UNION

            SELECT
                df.accession_id,
                df.item_name,
                df.quantity,
                df.device_type
            FROM devices_full df
            WHERE TRIM(LOWER(df.device_type)) = 'consumable'
              AND NOT EXISTS (
                SELECT 1
                FROM consumables c2
                WHERE c2.accession_id = df.accession_id
              )
              AND TRIM(LOWER(df.item_name)) NOT REGEXP '(ssd|storage|hdd|hard.?drive)'

            ORDER BY item_name
            """
        )

        rows = cursor.fetchall() or []

        return jsonify({
            "consumables": rows
        })

    except Exception as e:
        print(f"❌ Error fetching consumables: {e}")
        return jsonify({"consumables": []}), 500

    finally:
        cursor.close()
        conn.close()


# Load additional consumable routes defined in consumable_sage.py
try:
    import consumable_sage  # noqa: F401
except Exception as _err:
    print("❌ Failed to import consumable_sage:", _err)


@transaction_bp.route('/pc_parts/api', methods=['GET'])
@check_permission('transaction', 'view')
def get_pc_parts():

    conn = get_db_connection()
    cursor = conn.cursor(pymysql.cursors.DictCursor)

    try:
        cursor.execute(
            """
            SELECT
                CONCAT('Motherboard:', TRIM(motherboard)) AS accession_id,
                TRIM(motherboard) AS item_name,
                COUNT(*) AS quantity,
                'Motherboard' AS device_type
            FROM pcinfofull
            WHERE motherboard IS NOT NULL AND TRIM(motherboard) != ''
            GROUP BY TRIM(motherboard)

            UNION ALL

            SELECT
                CONCAT('RAM:', TRIM(ram)) AS accession_id,
                TRIM(ram) AS item_name,
                COUNT(*) AS quantity,
                'RAM' AS device_type
            FROM pcinfofull
            WHERE ram IS NOT NULL AND TRIM(ram) != ''
            GROUP BY TRIM(ram)

            UNION ALL

            SELECT
                CONCAT('Storage:', TRIM(storage)) AS accession_id,
                TRIM(storage) AS item_name,
                COUNT(*) AS quantity,
                'Storage' AS device_type
            FROM pcinfofull
            WHERE storage IS NOT NULL AND TRIM(storage) != ''
            GROUP BY TRIM(storage)

            UNION ALL

            SELECT
                CONCAT('GPU:', TRIM(gpu)) AS accession_id,
                TRIM(gpu) AS item_name,
                COUNT(*) AS quantity,
                'GPU' AS device_type
            FROM pcinfofull
            WHERE gpu IS NOT NULL AND TRIM(gpu) != ''
            GROUP BY TRIM(gpu)

            UNION ALL

            SELECT
                CONCAT('PSU:', TRIM(psu)) AS accession_id,
                TRIM(psu) AS item_name,
                COUNT(*) AS quantity,
                'PSU' AS device_type
            FROM pcinfofull
            WHERE psu IS NOT NULL AND TRIM(psu) != ''
            GROUP BY TRIM(psu)

            UNION ALL

            SELECT
                CONCAT('Casing:', TRIM(casing)) AS accession_id,
                TRIM(casing) AS item_name,
                COUNT(*) AS quantity,
                'Casing' AS device_type
            FROM pcinfofull
            WHERE casing IS NOT NULL AND TRIM(casing) != ''
            GROUP BY TRIM(casing)

            ORDER BY device_type, item_name
            """
        )

        rows = cursor.fetchall() or []

        return jsonify({
            "consumables": rows
        })

    except Exception as e:
        print(f"❌ Error fetching PC parts: {e}")
        return jsonify({"consumables": []}), 500

    finally:
        cursor.close()
        conn.close()

@transaction_bp.route('/transactions/api', methods=['GET'])
@check_permission('transaction', 'view')
def get_transactions_api():
    # Pagination parameters
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 10, type=int)
    
    # Validate per_page
    if per_page not in [5, 10, 25, 50]:
        per_page = 10
    
    offset = (page - 1) * per_page
    
    # Filter parameters
    raw_filter = request.args.get('filter')
    if raw_filter is None:
        # Backward compatibility for older clients that sent `type`.
        raw_filter = request.args.get('type', 'all')

    filter_type = str(raw_filter).strip().lower()
    if filter_type in ('received', 'inbound', 'in'):
        filter_type = 'receive'
    elif filter_type in ('returned', 'outbound', 'out'):
        filter_type = 'return'
    elif filter_type not in ('all', 'receive', 'return'):
        filter_type = 'all'

    date_from = request.args.get('date_from', '').strip()
    date_to = request.args.get('date_to', '').strip()

    # Keep filtering resilient when users accidentally reverse the date range.
    if date_from and date_to and date_from > date_to:
        date_from, date_to = date_to, date_from

    conn = get_db_connection()
    cursor = conn.cursor(pymysql.cursors.DictCursor)

    try:
        # Build query depending on requested filter type. For 'return' we now
        # read from the dedicated `consumable_usage` table; for 'receive' keep
        # using `consumable_transactions`. Date filters reference the created_at
        # column of the chosen source.

        params = []

        if filter_type == 'receive':
            # Use consumable_transactions for receives
            base_query = """
                SELECT
                    t.transaction_id,
                    t.accession_id,
                    t.item_name,
                    t.action,
                    t.quantity,
                    t.previous_stock,
                    t.new_stock,
                    t.reason,
                    t.notes,
                    t.created_at,
                    u.username,
                    COALESCE(d.department_name, '') AS department_name,
                    COALESCE(d.category, '') AS department_category
                FROM consumable_transactions t
                LEFT JOIN users u ON u.user_id = t.performed_by
                LEFT JOIN devices_full df ON df.accession_id = t.accession_id
                LEFT JOIN departments d ON d.department_id = df.department_id
                WHERE UPPER(TRIM(t.action)) = 'RECEIVE'
            """

            if date_from:
                base_query += " AND DATE(t.created_at) >= %s"
                params.append(date_from)
            if date_to:
                base_query += " AND DATE(t.created_at) <= %s"
                params.append(date_to)

            count_query = f"SELECT COUNT(*) as total FROM ({base_query}) as count_table"
            cursor.execute(count_query, params)
            total = cursor.fetchone()["total"]

            query = base_query + " ORDER BY t.created_at DESC LIMIT %s OFFSET %s"
            params_with_pagination = params + [per_page, offset]
            cursor.execute(query, params_with_pagination)
            rows = cursor.fetchall()

        elif filter_type == 'return':
            # Ensure the usage table exists before querying it (may be created
            # lazily by usage/return handlers). This avoids SQL errors when the
            # table is not yet present.
            try:
                _ensure_consumable_usage_table(cursor)
            except Exception:
                # If ensuring the table fails, we'll let subsequent queries
                # handle the missing-table scenario.
                pass

            # Use consumable_usage for usage/returns
            base_query = """
                SELECT
                    u.id AS transaction_id,
                    u.accession_id,
                    u.item_name,
                    'RETURN' AS action,
                    u.quantity,
                    u.previous_stock,
                    u.new_stock,
                    u.reason,
                    u.notes,
                    u.created_at,
                    usr.username,
                    COALESCE(d.department_name, '') AS department_name,
                    COALESCE(d.category, '') AS department_category
                FROM consumable_usage u
                LEFT JOIN users usr ON usr.user_id = u.performed_by
                LEFT JOIN devices_full df ON df.accession_id = u.accession_id
                LEFT JOIN departments d ON d.department_id = u.department_id
                WHERE 1=1
            """

            if date_from:
                base_query += " AND DATE(u.created_at) >= %s"
                params.append(date_from)
            if date_to:
                base_query += " AND DATE(u.created_at) <= %s"
                params.append(date_to)

            count_query = f"SELECT COUNT(*) as total FROM ({base_query}) as count_table"
            cursor.execute(count_query, params)
            total = cursor.fetchone()["total"]

            query = base_query + " ORDER BY u.created_at DESC LIMIT %s OFFSET %s"
            params_with_pagination = params + [per_page, offset]
            cursor.execute(query, params_with_pagination)
            rows = cursor.fetchall()

        else:
            # Default/backwards-compat: return all transactions. Include both
            # legacy `consumable_transactions` and the dedicated
            # `consumable_usage` (newer returns) so "All" shows recent
            # returns as well as receives.
            try:
                _ensure_consumable_usage_table(cursor)
            except Exception:
                pass

            # Subquery for legacy consumable_transactions
            recv_sub = """
                SELECT
                    t.transaction_id AS transaction_id,
                    t.accession_id,
                    t.item_name,
                    t.action,
                    t.quantity,
                    t.previous_stock,
                    t.new_stock,
                    t.reason,
                    t.notes,
                    t.created_at,
                    u.username,
                    COALESCE(d.department_name, '') AS department_name,
                    COALESCE(d.category, '') AS department_category
                FROM consumable_transactions t
                LEFT JOIN users u ON u.user_id = t.performed_by
                LEFT JOIN devices_full df ON df.accession_id = t.accession_id
                LEFT JOIN departments d ON d.department_id = df.department_id
                WHERE 1=1
            """

            # Subquery for dedicated usage/return rows
            return_sub = """
                SELECT
                    u.id AS transaction_id,
                    u.accession_id,
                    u.item_name,
                    'RETURN' AS action,
                    u.quantity,
                    u.previous_stock,
                    u.new_stock,
                    u.reason,
                    u.notes,
                    u.created_at,
                    usr.username,
                    COALESCE(d.department_name, '') AS department_name,
                    COALESCE(d.category, '') AS department_category
                FROM consumable_usage u
                LEFT JOIN users usr ON usr.user_id = u.performed_by
                LEFT JOIN devices_full df ON df.accession_id = u.accession_id
                LEFT JOIN departments d ON d.department_id = u.department_id
                WHERE 1=1
            """

            # Apply date filters to both subqueries and build params in order
            recv_params = []
            return_params = []
            if date_from:
                recv_sub += " AND DATE(t.created_at) >= %s"
                recv_params.append(date_from)
                return_sub += " AND DATE(u.created_at) >= %s"
                return_params.append(date_from)
            if date_to:
                recv_sub += " AND DATE(t.created_at) <= %s"
                recv_params.append(date_to)
                return_sub += " AND DATE(u.created_at) <= %s"
                return_params.append(date_to)

            base_query = f"({recv_sub}) UNION ALL ({return_sub})"

            params_for_count = recv_params + return_params
            count_query = f"SELECT COUNT(*) as total FROM ({base_query}) as count_table"
            cursor.execute(count_query, params_for_count)
            total = cursor.fetchone()["total"]

            query = base_query + " ORDER BY created_at DESC LIMIT %s OFFSET %s"
            params_with_pagination = params_for_count + [per_page, offset]
            cursor.execute(query, params_with_pagination)
            rows = cursor.fetchall()

        transactions = []

        for r in rows:
            qty_change = r["quantity"]
            action_value = str(r.get("action") or "").strip().upper()

            transactions.append({
                "id": r["transaction_id"],
                "type": "receive" if action_value == "RECEIVE" else "return",
                "item_name": r["item_name"],
                "quantity_change": qty_change,
                "performed_by": r["username"],
                "performed_at": str(r["created_at"]),
                "notes": r.get("notes"),
                "reason": r.get("reason"),
                # department info (may be empty)
                "office": r.get("department_name"),
                "facility": r.get("department_category")
            })
        
        # Calculate total pages
        total_pages = (total + per_page - 1) // per_page

        return jsonify({
            "transactions": transactions,
            "pagination": {
                "page": page,
                "per_page": per_page,
                "total": total,
                "total_pages": total_pages,
                "has_prev": page > 1,
                "has_next": page < total_pages
            }
        })

    except Exception as e:
        print("❌ Transaction fetch error:", e)
        return jsonify({
            "transactions": [],
            "pagination": {
                "page": page,
                "per_page": per_page,
                "total": 0,
                "total_pages": 0,
                "has_prev": False,
                "has_next": False
            }
        }), 500

    finally:
        cursor.close()
        conn.close()

@transaction_bp.route('/transactions/stats')
def get_transaction_stats():

    conn = get_db_connection()
    cursor = conn.cursor(pymysql.cursors.DictCursor)

    try:

        # Total received (from consumable_transactions)
        cursor.execute("SELECT IFNULL(SUM(quantity), 0) AS total FROM consumable_transactions WHERE action = 'RECEIVE'")
        total_received = cursor.fetchone().get('total', 0) or 0

        # Total returned: include both legacy `consumable_transactions` with
        # action='RETURN' and dedicated `consumable_usage` entries.
        cursor.execute("SELECT IFNULL(SUM(quantity), 0) AS total FROM consumable_transactions WHERE action = 'RETURN'")
        total_return_tx = cursor.fetchone().get('total', 0) or 0
        try:
            cursor.execute("SELECT IFNULL(SUM(quantity), 0) AS total FROM consumable_usage")
            total_usage_tx = cursor.fetchone().get('total', 0) or 0
        except Exception:
            # If the table doesn't exist yet, treat as zero
            total_usage_tx = 0

        total_returned = int(total_return_tx) + int(total_usage_tx)

        return jsonify({
            "total_received": total_received,
            "total_returned": total_returned,
            "net_change": total_received - total_returned
        })

    finally:
        cursor.close()
        conn.close()

        
@transaction_bp.route('/consumables/receive', methods=['POST'])
@check_permission('transaction', 'add')
def receive_consumable():

    data = request.json or {}
    accession_id = _safe_int(data.get('accession_id'))
    item_name = _normalize_item_name(data.get('item_name'))
    requested_device_type = _normalize_item_name(data.get('device_type'))
    qty = _safe_int(data.get('quantity'))
    notes = (data.get('notes') or '').strip() or None
    reference_no = (data.get('reference') or '').strip() or None

    brand_model = (data.get('brand_model') or '').strip() or None
    raw_cost = data.get('cost')
    cost = _safe_positive_float(raw_cost)
    date_acquired = (data.get('date_acquired') or '').strip() or None
    accountable = (data.get('accountable') or '').strip() or None
    department_id = _safe_int(data.get('department_id'))

    performed_by = _safe_int(data.get('performed_by'))
    conn = get_db_connection()
    cursor = conn.cursor(pymysql.cursors.DictCursor)

    try:

        if qty is None or qty <= 0:
            return jsonify({"success": False, "message": "Invalid quantity"}), 400

        if performed_by is None:
            return jsonify({"success": False, "message": "Performed by is required"}), 400

        if raw_cost not in (None, "") and cost is None:
            return jsonify({"success": False, "message": "Invalid cost value"}), 400

        cursor.execute("SELECT user_id FROM users WHERE user_id=%s LIMIT 1", (performed_by,))
        if not cursor.fetchone():
            return jsonify({"success": False, "message": "Selected user does not exist"}), 400

        # PC parts should stay in Manage Item and not appear in Manage Consumables.
        device_type = _resolve_device_type(item_name, requested_device_type)

        if accession_id is None:
            if not item_name:
                return jsonify({"success": False, "message": "Missing item"}), 400

            cursor.execute(
                """
                SELECT accession_id, quantity, item_name
                FROM devices_full
                WHERE TRIM(LOWER(device_type))=%s
                  AND TRIM(LOWER(item_name)) = TRIM(LOWER(%s))
                LIMIT 1
                """,
                (device_type.lower(), item_name)
            )
            existing = cursor.fetchone()

            if not existing and device_type.lower() != "consumable":
                # Migration-safe fallback: reuse legacy rows that were previously saved as consumables.
                cursor.execute(
                    """
                    SELECT accession_id, quantity, item_name
                    FROM devices_full
                    WHERE TRIM(LOWER(item_name)) = TRIM(LOWER(%s))
                    ORDER BY updated_at DESC, accession_id DESC
                    LIMIT 1
                    """,
                    (item_name,)
                )
                existing = cursor.fetchone()

            if existing:
                accession_id = existing["accession_id"]
                item_name = _normalize_item_name(existing.get("item_name")) or item_name

                if device_type.lower() != "consumable":
                    cursor.execute(
                        """
                        UPDATE devices_full
                        SET device_type = %s
                        WHERE accession_id = %s
                        """,
                        (device_type, accession_id),
                    )
            else:
                serial_no, municipal_serial_no = _generate_unique_serial_pair(cursor)

                cursor.execute(
                    """
                    INSERT INTO devices_full
                    (item_name, brand_model, date_acquired, accountable, serial_no, municipal_serial_no, quantity, device_type, status, department_id, acquisition_cost)
                    VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
                    """,
                    (item_name, brand_model, date_acquired or None, accountable, serial_no, municipal_serial_no, 0, device_type, "Available", department_id, cost),
                )
                accession_id = cursor.lastrowid

        cursor.execute(
            """
            SELECT quantity, item_name
            FROM devices_full
            WHERE accession_id=%s
            """,
            (accession_id,)
        )
        item = cursor.fetchone()

        if not item:
            cursor.execute(
                """
                SELECT item_name, quantity
                FROM consumables
                WHERE accession_id=%s
                """,
                (accession_id,)
            )
            legacy_item = cursor.fetchone()

            if legacy_item:
                legacy_name = _normalize_item_name(legacy_item.get("item_name")) or item_name or f"Item {accession_id}"
                legacy_qty = _safe_int(legacy_item.get("quantity")) or 0

                _bootstrap_device_from_consumables(
                    cursor,
                    accession_id=accession_id,
                    item_name=legacy_name,
                    quantity=legacy_qty,
                    device_type=_resolve_device_type(legacy_name, requested_device_type),
                    brand_model=brand_model,
                    date_acquired=date_acquired,
                    accountable=accountable,
                    department_id=department_id,
                    cost=cost,
                )

                cursor.execute(
                    """
                    SELECT quantity, item_name
                    FROM devices_full
                    WHERE accession_id=%s
                    """,
                    (accession_id,)
                )
                item = cursor.fetchone()

        if not item:
            return jsonify({"success": False, "message": "Item not found"}), 404

        previous_stock = _safe_int(item.get("quantity")) or 0
        resolved_item_name = _normalize_item_name(item.get("item_name")) or item_name or f"Item {accession_id}"
        new_stock = previous_stock + qty
        resolved_receive_type = _resolve_device_type(resolved_item_name, requested_device_type)

        if resolved_receive_type.lower() != "consumable":
            cursor.execute(
                """
                UPDATE devices_full
                SET device_type = %s
                WHERE accession_id = %s
                """,
                (resolved_receive_type, accession_id),
            )

        # Keep legacy rows visible in inventory pages that depend on device_type/item_name.
        _normalize_device_row_for_inventory_views(cursor, accession_id, resolved_item_name)

        # Update optional descriptive fields if provided
        if brand_model is not None or date_acquired is not None or accountable is not None or department_id is not None or cost is not None:
            cursor.execute(
                """
                UPDATE devices_full
                SET
                    brand_model = COALESCE(%s, brand_model),
                    date_acquired = COALESCE(%s, date_acquired),
                    accountable = COALESCE(%s, accountable),
                    department_id = COALESCE(%s, department_id),
                    acquisition_cost = COALESCE(%s, acquisition_cost)
                WHERE accession_id=%s
                """,
                (brand_model, date_acquired or None, accountable, department_id, cost, accession_id),
            )

        # Ensure FK target exists and keep quantities aligned
        _ensure_consumables_row(cursor, accession_id, resolved_item_name, previous_stock)

        cursor.execute(
            """
            UPDATE devices_full
            SET quantity=%s
            WHERE accession_id=%s
            """,
            (new_stock, accession_id)
        )

        cursor.execute(
            """
            UPDATE consumables
            SET quantity=%s, item_name=%s
            WHERE accession_id=%s
            """,
            (new_stock, resolved_item_name, accession_id),
        )

        cursor.execute("""
            INSERT INTO consumable_transactions
            (accession_id,item_name,action,quantity,previous_stock,new_stock,reference_no,notes,performed_by)
            VALUES (%s,%s,'RECEIVE',%s,%s,%s,%s,%s,%s)
        """, (
            accession_id,
            resolved_item_name,
            qty,
            previous_stock,
            new_stock,
            reference_no,
            notes,
            performed_by
        ))

        # Capture the inserted transaction and return it so the UI can update immediately
        inserted_id = cursor.lastrowid
        conn.commit()

        # Re-fetch the inserted transaction with related user and department info
        try:
            cursor.execute(
                """
                SELECT
                    t.transaction_id,
                    t.accession_id,
                    t.item_name,
                    t.action,
                    t.quantity,
                    t.previous_stock,
                    t.new_stock,
                    t.reason,
                    t.notes,
                    t.created_at,
                    u.username,
                    COALESCE(d.department_name, '') AS department_name,
                    COALESCE(d.category, '') AS department_category
                FROM consumable_transactions t
                LEFT JOIN users u ON u.user_id = t.performed_by
                LEFT JOIN devices_full df ON df.accession_id = t.accession_id
                LEFT JOIN departments d ON d.department_id = df.department_id
                WHERE t.transaction_id = %s
                LIMIT 1
                """,
                (inserted_id,)
            )
            row = cursor.fetchone()
            transaction = None
            if row:
                action_value = str(row.get('action') or '').strip().upper()
                transaction = {
                    'id': row.get('transaction_id'),
                    'type': 'receive' if action_value == 'RECEIVE' else 'return',
                    'item_name': row.get('item_name'),
                    'quantity_change': row.get('quantity'),
                    'performed_by': row.get('username'),
                    'performed_at': str(row.get('created_at')),
                    'notes': row.get('notes'),
                    'reason': row.get('reason'),
                    'office': row.get('department_name'),
                    'facility': row.get('department_category')
                }
        except Exception:
            transaction = None

        return jsonify({"success": True, "item_name": resolved_item_name, "new_stock": new_stock, "transaction": transaction})

    except Exception as e:
        try:
            conn.rollback()
        except Exception:
            pass
        print("❌ Receive error:", e)
        return jsonify({"success": False, "message": str(e)}), 500

    finally:
        cursor.close()
        conn.close()

@transaction_bp.route('/consumables/return', methods=['POST'])
@check_permission('transaction', 'add')
def return_consumable():

    # Accept either form-encoded POSTs or JSON body (some clients submit forms).
    data = request.form.to_dict() if request.form else (request.get_json(silent=True) or {})
    # If the client supplied a department for this usage, capture it so we can
    # reflect it in the returned transaction payload (does not modify inventory).
    department_id_submitted = _safe_int(data.get('department_id'))
    accession_id = _safe_int(data.get('accession_id'))
    qty = _safe_int(data.get('quantity'))
    reason = (data.get('reason') or '').strip() or None
    reference_no = (data.get('reference') or '').strip() or None
    notes = (data.get('notes') or '').strip() or None

    performed_by = _safe_int(data.get('performed_by'))
    conn = get_db_connection()
    cursor = conn.cursor(pymysql.cursors.DictCursor)

    try:

        if accession_id is None:
            return jsonify({"success": False, "message": "Missing item"}), 400

        if qty is None or qty <= 0:
            return jsonify({"success": False, "message": "Invalid quantity"}), 400

        if performed_by is None:
            return jsonify({"success": False, "message": "Performed by is required"}), 400

        cursor.execute("SELECT user_id FROM users WHERE user_id=%s LIMIT 1", (performed_by,))
        if not cursor.fetchone():
            return jsonify({"success": False, "message": "Selected user does not exist"}), 400

        cursor.execute(
            """
            SELECT quantity, item_name
            FROM devices_full
            WHERE accession_id=%s
            """,
            (accession_id,)
        )
        item = cursor.fetchone()

        if not item:
            cursor.execute(
                """
                SELECT item_name, quantity
                FROM consumables
                WHERE accession_id=%s
                """,
                (accession_id,)
            )
            legacy_item = cursor.fetchone()

            if legacy_item:
                legacy_name = _normalize_item_name(legacy_item.get("item_name")) or f"Item {accession_id}"
                legacy_qty = _safe_int(legacy_item.get("quantity")) or 0

                _bootstrap_device_from_consumables(
                    cursor,
                    accession_id=accession_id,
                    item_name=legacy_name,
                    quantity=legacy_qty,
                    device_type=_resolve_device_type(legacy_name),
                )

                cursor.execute(
                    """
                    SELECT quantity, item_name
                    FROM devices_full
                    WHERE accession_id=%s
                    """,
                    (accession_id,)
                )
                item = cursor.fetchone()

        if not item:
            return jsonify({"success": False, "message": "Item not found"}), 404

        previous_stock = _safe_int(item.get("quantity")) or 0
        resolved_item_name = _normalize_item_name(item.get("item_name")) or f"Item {accession_id}"

        if qty > previous_stock:
            return jsonify({"success": False, "message": f"Not enough stock. Available: {previous_stock}"}), 400

        new_stock = previous_stock - qty

        # Keep legacy rows visible in inventory pages that depend on device_type/item_name.
        _normalize_device_row_for_inventory_views(cursor, accession_id, resolved_item_name)

        # Ensure FK target exists and keep quantities aligned
        _ensure_consumables_row(cursor, accession_id, resolved_item_name, previous_stock)

        cursor.execute(
            """
            UPDATE devices_full
            SET quantity=%s
            WHERE accession_id=%s
            """,
            (new_stock, accession_id)
        )

        cursor.execute(
            """
            UPDATE consumables
            SET quantity=%s, item_name=%s
            WHERE accession_id=%s
            """,
            (new_stock, resolved_item_name, accession_id),
        )

        # Ensure a dedicated usage table exists and insert usage record there
        try:
            cursor.execute("""
                CREATE TABLE IF NOT EXISTS consumable_usage (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    accession_id INT NOT NULL,
                    item_name VARCHAR(255) DEFAULT NULL,
                    quantity INT NOT NULL,
                    previous_stock INT DEFAULT NULL,
                    new_stock INT DEFAULT NULL,
                    reference_no VARCHAR(100) DEFAULT NULL,
                    reason VARCHAR(255) DEFAULT NULL,
                    notes TEXT DEFAULT NULL,
                    performed_by INT DEFAULT NULL,
                    department_id INT DEFAULT NULL,
                    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
            """)
        except Exception:
            pass

        cursor.execute(
            """
            INSERT INTO consumable_usage
            (accession_id,item_name,quantity,previous_stock,new_stock,reference_no,reason,notes,performed_by,department_id)
            VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
        """,
        (
            accession_id,
            resolved_item_name,
            qty,
            previous_stock,
            new_stock,
            reference_no,
            reason,
            notes,
            performed_by,
            department_id_submitted
        ))

        inserted_id = cursor.lastrowid
        conn.commit()

        # Re-fetch the inserted usage row for immediate client update
        transaction = None
        try:
            cursor.execute(
                """
                SELECT
                    u.id AS transaction_id,
                    u.accession_id,
                    u.item_name,
                    'RETURN' AS action,
                    u.quantity,
                    u.previous_stock,
                    u.new_stock,
                    u.reason,
                    u.notes,
                    u.created_at,
                    usr.username,
                    COALESCE(d.department_name, '') AS department_name,
                    COALESCE(d.category, '') AS department_category
                FROM consumable_usage u
                LEFT JOIN users usr ON usr.user_id = u.performed_by
                LEFT JOIN devices_full df ON df.accession_id = u.accession_id
                LEFT JOIN departments d ON d.department_id = u.department_id
                WHERE u.id = %s
                LIMIT 1
                """,
                (inserted_id,)
            )
            row = cursor.fetchone()
            if row:
                action_value = str(row.get('action') or '').strip().upper()

                office = row.get('department_name')
                facility = row.get('department_category')
                try:
                    if department_id_submitted is not None:
                        cursor.execute("SELECT department_name, category FROM departments WHERE department_id=%s LIMIT 1", (department_id_submitted,))
                        drow = cursor.fetchone()
                        if drow:
                            office = drow.get('department_name') or office
                            facility = drow.get('category') or facility
                except Exception:
                    pass

                transaction = {
                    'id': row.get('transaction_id'),
                    'type': 'receive' if action_value == 'RECEIVE' else 'return',
                    'item_name': row.get('item_name'),
                    'quantity_change': row.get('quantity'),
                    'performed_by': row.get('username'),
                    'performed_at': str(row.get('created_at')),
                    'notes': row.get('notes'),
                    'reason': row.get('reason'),
                    'office': office,
                    'facility': facility
                }
        except Exception:
            transaction = None

        return jsonify({"success": True, "item_name": resolved_item_name, "new_stock": new_stock, "transaction": transaction})

    except Exception as e:
        try:
            conn.rollback()
        except Exception:
            pass
        print("❌ Return error:", e)
        return jsonify({"success": False, "message": str(e)}), 500

    finally:
        cursor.close()
        conn.close()
    


# /consumables/use moved to consumable_sage.py


@transaction_bp.route('/users/list', methods=['GET'])
@check_permission('transaction', 'view')
def get_users():

    conn = get_db_connection()
    cursor = conn.cursor(pymysql.cursors.DictCursor)

    try:
        users = _fetch_selectable_users(cursor)

        response = make_response(jsonify({"users": users}))
        response.headers['Cache-Control'] = 'no-store, no-cache, must-revalidate, max-age=0'
        response.headers['Pragma'] = 'no-cache'
        return response

    finally:
        cursor.close()
        conn.close()