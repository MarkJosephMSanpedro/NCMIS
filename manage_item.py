from db import get_db_connection
import pymysql
from flask import Blueprint, render_template, request, redirect, url_for, flash, jsonify, send_file
from io import BytesIO
import pandas as pd
import qrcode, os
import time,random
import re
from openpyxl.styles import Font, Alignment, PatternFill
from openpyxl.utils import get_column_letter

manage_item_bp = Blueprint('manage_item_bp', __name__, template_folder='templates')


# ✅ Get Devices with Departments
@manage_item_bp.route('/get-devices-with-details')
def get_devices_with_details():
    conn = get_db_connection()
    try:
        # Detect if the schema has is_archived; if not, avoid referencing it
        try:
            with conn.cursor() as _cur:
                _cur.execute("SELECT COUNT(*) AS cnt FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'devices_full' AND COLUMN_NAME = 'is_archived'")
                _row = _cur.fetchone()
                has_is_arch = bool(_row and (int(_row.get('cnt', 0)) if isinstance(_row, dict) else _row[0] > 0))
        except Exception:
            has_is_arch = False

        arch_clause = 'WHERE df.is_archived = 0' if has_is_arch else 'WHERE 1=1'

        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            cur.execute(f"""
                SELECT 
                    df.accession_id,
                    df.item_name,
                    df.brand_model,
                    df.serial_no,
                    df.municipal_serial_no,
                    df.quantity,
                    df.device_type,
                    df.acquisition_cost,
                    df.date_acquired,
                    df.accountable,
                    df.status AS unit_status,
                    df.maintenance_interval_days,
                    df.last_checked,
                    dep.department_id,
                    dep.department_name
                FROM devices_full df
                LEFT JOIN departments dep ON df.department_id = dep.department_id
                {arch_clause}
                ORDER BY df.accession_id
            """)
            return cur.fetchall()
    except Exception as e:
        print(f"Error fetching devices_full: {e}")
        return []
    finally:
        conn.close()


# ✅ Fetch Departments
@manage_item_bp.route('/get-departments')
def get_departments():
    conn = get_db_connection()
    with conn.cursor(pymysql.cursors.DictCursor) as cur:
        cur.execute("SELECT department_id, department_name FROM departments ORDER BY department_name")
        results = cur.fetchall()
    conn.close()
    return jsonify(results)


@manage_item_bp.route('/add-device', methods=['POST'])
def add_device():
    conn = get_db_connection()
    try:
        form = request.form
        item_name = form.get('item_name')
        brand_model = form.get('brand_model')
        device_type = form.get('device_type')
        acquisition_cost = form.get('acquisition_cost')
        date_acquired = form.get('date_acquired')
        accountable = form.get('accountable')
        department_id = form.get('department_id')
        status = form.get('status') or 'Available'
        quantity = int(form.get('quantity', 1))
        maintenance_interval_days = int(form.get('maintenance_interval_days', 30))

        inserted_ids = []

        with conn.cursor() as cur:
            is_consumable = (device_type or '').strip().lower() == 'consumable'
            insert_count = 1 if is_consumable else quantity

            for _ in range(insert_count):
                # Auto-generate serials
                serial_no = generate_unique_serial("SN")
                municipal_serial_no = generate_unique_serial("MSN")

                # Ensure uniqueness in DB
                while True:
                    cur.execute("""
                        SELECT COUNT(*) AS count FROM devices_full
                        WHERE serial_no=%s OR municipal_serial_no=%s
                    """, (serial_no, municipal_serial_no))
                    if cur.fetchone()['count'] == 0:
                        break
                    serial_no = generate_unique_serial("SN")
                    municipal_serial_no = generate_unique_serial("MSN")

                cur.execute("""
                    INSERT INTO devices_full (
                        item_name, brand_model, serial_no, municipal_serial_no, quantity,
                        device_type, acquisition_cost, date_acquired, accountable,
                        department_id, status, maintenance_interval_days
                    ) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
                """, (
                    item_name, brand_model, serial_no, municipal_serial_no,
                    quantity if is_consumable else 1,
                    device_type, acquisition_cost, date_acquired, accountable,
                    department_id, status, maintenance_interval_days
                ))
                inserted_ids.append(cur.lastrowid)

        conn.commit()
        flash(f"{quantity} device(s) added successfully!", "success")
        return redirect(url_for('manage_inventory.inventory_load'))
    except Exception as e:
        conn.rollback()
        print(f"❌ Error adding device: {e}")
        flash("Error adding device.", "danger")
        return redirect(url_for('manage_inventory.inventory_load'))
    finally:
        conn.close()

@manage_item_bp.route('/update-device', methods=['POST'])
def update_device():
    conn = get_db_connection()
    try:
        form = request.form
        accession_id = form.get('accession_id')
        if not accession_id:
            flash("Missing device ID.", "danger")
            return redirect(url_for('manage_inventory.inventory_load'))

        with conn.cursor() as cur:
            # Check for duplicates before updating
            cur.execute("""
                SELECT COUNT(*) AS count FROM devices_full
                WHERE (serial_no=%s OR municipal_serial_no=%s) AND accession_id != %s
            """, (form.get('serial_no'), form.get('municipal_serial_no'), accession_id))
            if cur.fetchone()['count'] > 0:
                flash("Serial No or Municipal Serial No already exists!", "danger")
                return redirect(url_for('manage_inventory.inventory_load'))

            cur.execute("""
                UPDATE devices_full
                SET item_name=%s,
                    brand_model=%s,
                    serial_no=%s,
                    municipal_serial_no=%s,
                    device_type=%s,
                    acquisition_cost=%s,
                    date_acquired=%s,
                    accountable=%s,
                    quantity=%s,
                    department_id=%s,
                    status=%s,
                    maintenance_interval_days=%s
                WHERE accession_id=%s
            """, (
                form.get('item_name'),
                form.get('brand_model'),
                form.get('serial_no'),
                form.get('municipal_serial_no'),
                form.get('device_type'),
                form.get('acquisition_cost'),
                form.get('date_acquired'),
                form.get('accountable'),
                form.get('quantity', 1),
                form.get('department_id'),
                form.get('status'),
                form.get('maintenance_interval_days', 30),
                accession_id
            ))
            conn.commit()
        flash("Device updated successfully!", "success")
        return redirect(url_for('manage_inventory.inventory_load'))
    except Exception as e:
        conn.rollback()
        print(f"❌ Error updating device: {e}")
        flash("Error updating device.", "danger")
        return redirect(url_for('manage_inventory.inventory_load'))
    finally:
        conn.close()

# ✅ Delete Device

@manage_item_bp.route('/delete-item/<int:id>', methods=['POST'])
def delete_item(id):
    is_ajax = request.headers.get('X-Requested-With') == 'XMLHttpRequest'
    conn = get_db_connection()
    try:
        with conn.cursor() as cur:
            cur.execute("UPDATE devices_full SET is_archived = 1, deleted_at = NOW() WHERE accession_id = %s", (id,))
            conn.commit()
        if is_ajax:
            return jsonify(success=True, message='Device archived successfully!')
        flash("Device archived successfully!", "success")
    except Exception as e:
        conn.rollback()
        if is_ajax:
            return jsonify(success=False, error=f"Error archiving device: {e}"), 500
        flash(f"Error archiving device: {e}", "danger")
    finally:
        conn.close()
    return redirect(url_for('manage_inventory.inventory_load'))


# ✅ Get Item by ID
@manage_item_bp.route('/get-item-by-id/<int:item_id>')
def get_item_by_id(item_id):
    conn = get_db_connection()
    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            cur.execute("""
                SELECT 
                    df.accession_id,
                    df.item_name,
                    df.brand_model,
                    df.serial_no,
                    df.municipal_serial_no,
                    df.quantity,
                    df.device_type,
                    df.acquisition_cost,
                    df.date_acquired,
                    df.accountable,
                    df.status,
                    df.maintenance_interval_days,
                    dep.department_id,
                    dep.department_name
                FROM devices_full df
                LEFT JOIN departments dep ON df.department_id = dep.department_id
                WHERE df.accession_id = %s
            """, (item_id,))
            item = cur.fetchone()

        if not item:
            return jsonify({'error': 'Item not found'}), 404
        return jsonify(item)

    except Exception as e:
        print(f"❌ Error fetching item by ID: {e}")
        return jsonify({'error': 'Database error'}), 500
    finally:
        conn.close()


# ✅ Check if serial_no or municipal_serial_no already exists
@manage_item_bp.route('/check-serial-duplicate')
def check_serial_duplicate():
    serial_no = request.args.get('serial_no', '').strip()
    municipal_serial_no = request.args.get('municipal_serial_no', '').strip()
    accession_id = request.args.get('accession_id')  # optional for edit mode

    if not serial_no and not municipal_serial_no:
        return jsonify({'duplicate': False})  # return valid JSON even if empty

    conn = get_db_connection()
    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            query = """
                SELECT COUNT(*) AS count FROM devices_full
                WHERE (serial_no=%s OR municipal_serial_no=%s)
            """
            params = [serial_no, municipal_serial_no]
            if accession_id:
                query += " AND accession_id != %s"
                params.append(accession_id)

            cur.execute(query, params)
            result = cur.fetchone()
            duplicate = result['count'] > 0
        return jsonify({"duplicate": duplicate})
    finally:
        conn.close()

def generate_unique_serial(prefix="SN"):
    """Generate a unique serial number"""
    return f"{prefix}{int(time.time()*1000) % 1000000}{random.randint(10,99)}"


@manage_item_bp.route('/filter-device', methods=['GET'])
def filter_devices():
    """Filter devices dynamically based on query parameters."""
    conn = get_db_connection()
    try:
        # Get all possible query parameters
        department_id = request.args.get('department_id')
        status = request.args.get('status')
        location = request.args.get('location')
        accountable = request.args.get('accountable')
        serial_no = request.args.get('serial_no')
        item_name = request.args.get('item_name')
        brand_model = request.args.get('brand_model')
        device_type = request.args.get('device_type')
        quantity = request.args.get('quantity')
        acquisition_cost = request.args.get('acquisition_cost')
        date_from = request.args.get('date_from')
        date_to = request.args.get('date_to')

        # Normalize status for case-insensitive comparisons
        status_norm = status.strip().lower() if isinstance(status, str) and status.strip() else None

        query = """
            SELECT 
                df.accession_id,
                df.item_name,
                df.brand_model,
                df.serial_no,
                df.municipal_serial_no,
                df.quantity,
                df.device_type,
                df.acquisition_cost,
                df.date_acquired,
                df.accountable,
                df.status,
                df.risk_level,
                df.health_score,
                dep.department_id,
                dep.department_name
            FROM devices_full df
            LEFT JOIN departments dep ON df.department_id = dep.department_id
            WHERE COALESCE(df.is_archived, 0) = 0 AND LOWER(COALESCE(df.status, '')) != 'surrendered'
        """
        params = []

        # Apply filters dynamically
        if department_id:
            query += " AND df.department_id = %s"
            params.append(department_id)
        if status:
            query += " AND LOWER(COALESCE(df.status, '')) = %s"
            params.append(status_norm)
        if location:
            query += " AND df.location LIKE %s"
            params.append(f"%{location}%")
        if accountable:
            query += " AND df.accountable LIKE %s"
            params.append(f"%{accountable}%")
        if serial_no:
            query += " AND (df.serial_no LIKE %s OR df.municipal_serial_no LIKE %s)"
            params.extend([f"%{serial_no}%", f"%{serial_no}%"])
        if item_name:
            query += " AND df.item_name LIKE %s"
            params.append(f"%{item_name}%")
        if brand_model:
            query += " AND df.brand_model LIKE %s"
            params.append(f"%{brand_model}%")
        if device_type:
            query += " AND df.device_type LIKE %s"
            params.append(f"%{device_type}%")
        if quantity:
            query += " AND df.quantity = %s"
            params.append(quantity)
        if acquisition_cost:
            query += " AND df.acquisition_cost = %s"
            params.append(acquisition_cost)

        if date_from and date_to:
            query += " AND df.date_acquired BETWEEN %s AND %s"
            params.extend([date_from, date_to])

        query += " ORDER BY df.accession_id"

        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            cur.execute(query, params)
            devices = cur.fetchall()

        return jsonify(devices)

    except Exception as e:
        print(f"❌ Error filtering devices: {e}")
        return jsonify({"error": "Error filtering devices."}), 500
    finally:
        conn.close()


@manage_item_bp.route('/device-filter-modal')
def device_filter_modal():
    departments = get_departments()
    return render_template('partials/filter_device_modal.html', departments=departments)


@manage_item_bp.route('/export-selected-devices', methods=['POST'])
def export_selected_devices():
    data = request.get_json(silent=True) or {}
    device_ids = data.get("device_ids") or []

    try:
        device_ids = [int(device_id) for device_id in device_ids]
    except (TypeError, ValueError):
        return jsonify({"error": "Invalid device selection"}), 400

    if not device_ids:
        return jsonify({"error": "No devices selected"}), 400

    conn = get_db_connection()

    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            placeholders = ','.join(['%s'] * len(device_ids))
            cur.execute(
                f"""
                SELECT
                    df.accession_id,
                    df.item_name,
                    df.brand_model,
                    df.serial_no,
                    df.municipal_serial_no,
                    df.device_type,
                    df.quantity,
                    df.acquisition_cost,
                    df.date_acquired,
                    df.accountable,
                    COALESCE(dep.department_name, '') AS department,
                    df.status
                FROM devices_full df
                LEFT JOIN departments dep ON dep.department_id = df.department_id
                WHERE df.accession_id IN ({placeholders})
                ORDER BY df.accession_id
                """,
                tuple(device_ids)
            )
            rows = cur.fetchall()

        if not rows:
            return jsonify({"error": "No matching devices found for export"}), 404

        df = pd.DataFrame(rows).rename(columns={
            "accession_id": "ID",
            "item_name": "Device Name",
            "brand_model": "Brand / Model",
            "serial_no": "Serial No",
            "municipal_serial_no": "Municipal Serial No",
            "device_type": "Device Type",
            "quantity": "Quantity",
            "acquisition_cost": "Acquisition Cost",
            "date_acquired": "Date Acquired",
            "accountable": "Accountable",
            "department": "Department",
            "status": "Status",
        })

        output = BytesIO()
        with pd.ExcelWriter(output, engine='openpyxl') as writer:
            df.to_excel(writer, index=False, sheet_name='Selected Devices')

            ws = writer.sheets.get('Selected Devices')
            if ws:
                ws.freeze_panes = 'A2'
                ws.auto_filter.ref = ws.dimensions

                header_font = Font(bold=True, color="FFFFFF")
                header_fill = PatternFill("solid", fgColor="1D4ED8")
                header_alignment = Alignment(horizontal="center", vertical="center", wrap_text=True)

                for cell in ws[1]:
                    cell.font = header_font
                    cell.fill = header_fill
                    cell.alignment = header_alignment

                ws.row_dimensions[1].height = 20

                currency_headers = {"Acquisition Cost"}
                date_headers = {"Date Acquired"}

                for col_idx, column_cells in enumerate(ws.columns, start=1):
                    column_letter = get_column_letter(col_idx)
                    header_value = column_cells[0].value

                    max_length = 0
                    for cell in column_cells:
                        if cell.value is None:
                            continue
                        cell_value = str(cell.value)
                        if len(cell_value) > max_length:
                            max_length = len(cell_value)

                        if cell.row == 1:
                            continue

                        if header_value in currency_headers:
                            cell.number_format = '#,##0.00'
                            cell.alignment = Alignment(horizontal="right", vertical="top")
                        elif header_value in date_headers:
                            cell.number_format = 'yyyy-mm-dd'
                            cell.alignment = Alignment(horizontal="center", vertical="top")
                        else:
                            cell.alignment = Alignment(horizontal="left", vertical="top", wrap_text=False)

                    padded = min(max(max_length + 2, 10), 42)
                    ws.column_dimensions[column_letter].width = padded

        output.seek(0)

        return send_file(
            output,
            as_attachment=True,
            download_name="selected_devices.xlsx",
            mimetype="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        )

    except Exception as e:
        print(f"❌ Device export error: {e}")
        return jsonify({"error": str(e)}), 500

    finally:
        conn.close()


@manage_item_bp.route('/import-devices-excel', methods=['POST'])
def import_devices_excel():
    file = request.files.get("file")
    duplicate_option = request.form.get("duplicate_option", "skip")

    if not file:
        return jsonify({"success": False, "error": "No file uploaded"})

    if duplicate_option not in {"skip", "ignore", "overwrite"}:
        duplicate_option = "skip"

    conn = None

    try:
        df = pd.read_excel(file)

        def normalize_header(name):
            text = str(name).strip().lower()
            text = re.sub(r"[^a-z0-9]+", "_", text)
            return text.strip("_")

        df = df.rename(columns={col: normalize_header(col) for col in df.columns})

        alias_map = {
            "device_name": "item_name",
            "department_name": "department",
        }
        for old_name, new_name in alias_map.items():
            if old_name in df.columns and new_name not in df.columns:
                df[new_name] = df[old_name]

        conn = get_db_connection()
        cur = conn.cursor(pymysql.cursors.DictCursor)

        added = 0
        updated = 0
        skipped = 0

        department_cache = {}

        def clean_value(value):
            if pd.isna(value):
                return None
            if isinstance(value, str):
                value = value.strip()
                return value or None
            if isinstance(value, pd.Timestamp):
                return value.date()
            return value

        for _, row in df.iterrows():
            item_name = clean_value(row.get("item_name"))
            brand_model = clean_value(row.get("brand_model"))
            serial = clean_value(row.get("serial_no"))
            municipal = clean_value(row.get("municipal_serial_no"))
            device_type = clean_value(row.get("device_type"))
            acquisition_cost = clean_value(row.get("acquisition_cost"))
            date_acquired = clean_value(row.get("date_acquired"))
            accountable = clean_value(row.get("accountable"))
            status = clean_value(row.get("status")) or "Available"

            quantity = clean_value(row.get("quantity"))
            try:
                quantity = max(1, int(quantity)) if quantity is not None else 1
            except (TypeError, ValueError):
                quantity = 1

            maintenance_interval_days = clean_value(row.get("maintenance_interval_days"))
            try:
                maintenance_interval_days = int(maintenance_interval_days) if maintenance_interval_days is not None else 30
            except (TypeError, ValueError):
                maintenance_interval_days = 30
            maintenance_interval_days = max(1, maintenance_interval_days)

            department_id = clean_value(row.get("department_id"))
            department_name = clean_value(row.get("department"))

            if not department_id and department_name:
                if department_name not in department_cache:
                    cur.execute(
                        "SELECT department_id FROM departments WHERE department_name = %s LIMIT 1",
                        (department_name,)
                    )
                    dept_row = cur.fetchone()
                    department_cache[department_name] = dept_row["department_id"] if dept_row else None
                department_id = department_cache.get(department_name)

            if not item_name:
                skipped += 1
                continue

            if not serial and not municipal:
                skipped += 1
                continue

            existing = None
            if serial and municipal:
                cur.execute(
                    "SELECT accession_id FROM devices_full WHERE serial_no = %s OR municipal_serial_no = %s LIMIT 1",
                    (serial, municipal)
                )
                existing = cur.fetchone()
            elif serial:
                cur.execute(
                    "SELECT accession_id FROM devices_full WHERE serial_no = %s LIMIT 1",
                    (serial,)
                )
                existing = cur.fetchone()
            elif municipal:
                cur.execute(
                    "SELECT accession_id FROM devices_full WHERE municipal_serial_no = %s LIMIT 1",
                    (municipal,)
                )
                existing = cur.fetchone()

            normalized_status = str(status).strip().lower()
            imported_risk = "High" if normalized_status in {"damaged", "damage", "unusable"} else "Low"

            if existing:
                if duplicate_option in {"skip", "ignore"}:
                    skipped += 1
                    continue

                if duplicate_option == "overwrite":
                    cur.execute(
                        """
                        UPDATE devices_full SET
                            item_name = COALESCE(%s, item_name),
                            brand_model = COALESCE(%s, brand_model),
                            quantity = COALESCE(%s, quantity),
                            device_type = COALESCE(%s, device_type),
                            acquisition_cost = COALESCE(%s, acquisition_cost),
                            date_acquired = COALESCE(%s, date_acquired),
                            accountable = COALESCE(%s, accountable),
                            department_id = COALESCE(%s, department_id),
                            status = COALESCE(%s, status),
                            maintenance_interval_days = COALESCE(%s, maintenance_interval_days),
                            risk_level = CASE
                                WHEN LOWER(TRIM(COALESCE(%s, status))) IN ('damaged', 'damage', 'unusable') THEN 'High'
                                ELSE risk_level
                            END
                        WHERE accession_id = %s
                        """,
                        (
                            item_name,
                            brand_model,
                            quantity,
                            device_type,
                            acquisition_cost,
                            date_acquired,
                            accountable,
                            department_id,
                            status,
                            maintenance_interval_days,
                            status,
                            existing["accession_id"],
                        ),
                    )
                    updated += 1
                    continue

            cur.execute(
                """
                INSERT INTO devices_full
                (item_name, brand_model, serial_no, municipal_serial_no, quantity,
                 device_type, acquisition_cost, date_acquired, accountable,
                 department_id, status, maintenance_interval_days,
                 last_checked, health_score, risk_level)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, CURDATE(), 100, %s)
                """,
                (
                    item_name,
                    brand_model,
                    serial,
                    municipal,
                    quantity,
                    device_type,
                    acquisition_cost,
                    date_acquired,
                    accountable,
                    department_id,
                    status,
                    maintenance_interval_days,
                    imported_risk,
                ),
            )
            added += 1

        conn.commit()

        return jsonify({
            "success": True,
            "added": added,
            "updated": updated,
            "skipped": skipped,
        })

    except Exception as e:
        print(f"❌ Device import error: {e}")
        return jsonify({"success": False, "error": str(e)})

    finally:
        if conn:
            conn.close()
