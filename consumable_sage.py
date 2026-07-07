from flask import render_template, session, make_response, redirect, url_for, request, jsonify
import pymysql

# Import helpers and blueprint from transaction module (transaction_bp is already registered in app)
from transaction import (
    transaction_bp,
    _safe_int,
    _normalize_item_name,
    _resolve_device_type,
    _bootstrap_device_from_consumables,
    _normalize_device_row_for_inventory_views,
    _ensure_consumables_row,
    get_db_connection,
)

from utils.permissions import check_permission


@transaction_bp.route('/consumable-usage')
@check_permission('transaction', 'view')
def consumable_usage_page():
    """Render a standalone Consumable Usage page (was previously a modal)."""
    current_user_id = None
    try:
        current_session_user = session.get('user') or {}
        current_user_id = _safe_int(current_session_user.get('user_id'))
    except Exception:
        current_user_id = None

    response = make_response(render_template('consumable_usage.html', current_user_id=current_user_id))
    response.headers['Cache-Control'] = 'no-store, no-cache, must-revalidate, max-age=0'
    response.headers['Pragma'] = 'no-cache'
    return response


@transaction_bp.route('/consumables/use', methods=['POST'])
@check_permission('transaction', 'add')
def use_consumable():
    # Detect AJAX/JSON callers so we can return JSON responses for API usage.
    is_ajax = (
        request.is_json or
        request.headers.get('X-Requested-With') == 'XMLHttpRequest' or
        ('application/json' in (request.headers.get('Accept') or ''))
    )

    # Accept either form-encoded POSTs or JSON body
    data = request.form.to_dict() if request.form else (request.get_json(silent=True) or {})
    # Allow overriding the returned department for this transaction so the UI
    # can show the department selected by the user (this does not mutate
    # inventory rows; it's only used for the immediate response payload).
    department_id_submitted = _safe_int(data.get('department_id'))

    # Debugging: log incoming request headers and parsed data to help diagnose 400s
    try:
        print("[DEBUG] /consumables/use is_ajax:", is_ajax)
        try:
            hdrs = dict(request.headers)
        except Exception:
            hdrs = list(request.headers)
        print("[DEBUG] /consumables/use headers:", hdrs)
        print("[DEBUG] /consumables/use parsed data:", data)
        print("[DEBUG] session user:", session.get('user'))
    except Exception:
        pass

    accession_id = _safe_int(data.get('accession_id'))
    qty = _safe_int(data.get('quantity'))
    reason = (data.get('reason') or '').strip() or 'Used'
    reference_no = (data.get('reference') or '').strip() or None
    notes = (data.get('notes') or '').strip() or None

    performed_by = _safe_int(data.get('performed_by'))
    try:
        if performed_by is None:
            current_session_user = session.get('user') or {}
            performed_by = _safe_int(current_session_user.get('user_id'))
    except Exception:
        performed_by = None

    conn = get_db_connection()
    cursor = conn.cursor(pymysql.cursors.DictCursor)

    try:
        if accession_id is None:
            print("[DEBUG] /consumables/use returning 400: Missing item","data=", data)
            return jsonify({"success": False, "message": "Missing item"}), 400

        if qty is None or qty <= 0:
            print("[DEBUG] /consumables/use returning 400: Invalid quantity","data=", data)
            return jsonify({"success": False, "message": "Invalid quantity"}), 400

        if performed_by is None:
            print("[DEBUG] /consumables/use returning 400: Performed by missing","data=", data)
            return jsonify({"success": False, "message": "Performed by is required"}), 400

        cursor.execute("SELECT user_id FROM users WHERE user_id=%s LIMIT 1", (performed_by,))
        if not cursor.fetchone():
            print("[DEBUG] /consumables/use returning 400: Selected user does not exist","performed_by=", performed_by)
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
        # If a devices_full row exists but its quantity is zero or missing,
        # prefer the non-zero quantity from the legacy `consumables` table.
        # Conversely, if `devices_full` has a larger quantity, keep it.
        if item:
            df_qty = _safe_int(item.get('quantity')) or 0
            # Attempt to read legacy consumables quantity to reconcile
            try:
                cursor.execute(
                    """
                    SELECT item_name, quantity
                    FROM consumables
                    WHERE accession_id=%s
                    """,
                    (accession_id,)
                )
                legacy_item = cursor.fetchone()
            except Exception:
                legacy_item = None

            legacy_qty = _safe_int(legacy_item.get('quantity')) or 0 if legacy_item else 0
            # Use the larger of the two quantities so we don't underreport stock
            chosen_qty = df_qty if df_qty >= legacy_qty else legacy_qty
            # If we chose the legacy qty and devices_full had a lower value, update
            # the item object so downstream logic uses the reconciled quantity.
            if chosen_qty != df_qty:
                # mutate the fetched item dict if possible
                try:
                    item['quantity'] = chosen_qty
                    if legacy_item and legacy_item.get('item_name'):
                        item['item_name'] = legacy_item.get('item_name')
                except Exception:
                    pass

        else:
            # No devices_full row; try to bootstrap from consumables (legacy)
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
            print("[DEBUG] /consumables/use returning 404: Item not found","accession_id=", accession_id)
            return jsonify({"success": False, "message": "Item not found"}), 404

        previous_stock = _safe_int(item.get("quantity")) or 0
        resolved_item_name = _normalize_item_name(item.get("item_name")) or f"Item {accession_id}"

        if qty > previous_stock:
            print(f"[DEBUG] /consumables/use returning 400: Not enough stock. Available: {previous_stock}")
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
                    'USE' AS action,
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

        if is_ajax:
            return jsonify({"success": True, "item_name": resolved_item_name, "new_stock": new_stock, "transaction": transaction})

        return redirect(url_for('transaction_bp.consumable_usage_page'))

    except Exception as e:
        try:
            conn.rollback()
        except Exception:
            pass
        print("❌ Usage error:", e)
        if is_ajax:
            return jsonify({"success": False, "message": str(e)}), 500
        return redirect(url_for('transaction_bp.consumable_usage_page'))
    finally:
        cursor.close()
        conn.close()
