from flask import Blueprint, render_template, flash, jsonify, request, redirect, url_for, send_file
from db import get_db_connection
import pymysql
import time, random
import pandas as pd
import re
from io import BytesIO

manage_consumable_bp = Blueprint('manage_consumable_bp', __name__, template_folder='templates')

# ✅ Get Departments
@manage_consumable_bp.route('/get-departments')
def get_departments():
    conn = get_db_connection()
    with conn.cursor(pymysql.cursors.DictCursor) as cur:
        cur.execute("SELECT department_id, department_name FROM departments ORDER BY department_name")
        results = cur.fetchall()
    conn.close()
    return jsonify(results)

# ✅ Filter Consumables
@manage_consumable_bp.route('/filter-consumable', methods=['GET'])
def filter_consumables():
    """Filter consumables dynamically based on query parameters."""
    conn = get_db_connection()
    try:
        # Get all possible query parameters
        department_id = request.args.get('department_id')
        status = request.args.get('status')
        accountable = request.args.get('accountable')
        item_name = request.args.get('item_name')
        brand_model = request.args.get('brand_model')
        quantity = request.args.get('quantity')
        acquisition_cost = request.args.get('acquisition_cost')
        date_from = request.args.get('date_from')
        date_to = request.args.get('date_to')

        query = """
            SELECT 
                df.accession_id,
                df.item_name,
                df.brand_model,
                df.quantity,
                df.acquisition_cost,
                df.date_acquired,
                df.accountable,
                df.status,
                df.risk_level,
                df.health_score,
                df.last_checked,
                df.maintenance_interval_days,
                dep.department_id,
                dep.department_name
            FROM devices_full df
            LEFT JOIN departments dep ON df.department_id = dep.department_id
            WHERE df.device_type = 'Consumable'
                AND COALESCE(df.is_archived, 0) = 0
        """
        params = []

        # Apply filters dynamically
        if department_id:
            query += " AND df.department_id = %s"
            params.append(department_id)
        if status:
            query += " AND df.status = %s"
            params.append(status)
        if accountable:
            query += " AND df.accountable LIKE %s"
            params.append(f"%{accountable}%")
        if item_name:
            query += " AND df.item_name LIKE %s"
            params.append(f"%{item_name}%")
        if brand_model:
            query += " AND df.brand_model LIKE %s"
            params.append(f"%{brand_model}%")
        if quantity:
            query += " AND df.quantity = %s"
            params.append(quantity)
        if acquisition_cost:
            query += " AND df.acquisition_cost = %s"
            params.append(acquisition_cost)

        if date_from and date_to:
            query += " AND df.date_acquired BETWEEN %s AND %s"
            params.extend([date_from, date_to])

        query += " ORDER BY df.accession_id DESC"

        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            cur.execute(query, params)
            consumables = cur.fetchall()

        print(consumables)
        return jsonify(consumables)

    except Exception as e:
        print(f"❌ Error filtering consumables: {e}")
        return jsonify({"error": "Error filtering consumables."}), 500
    finally:
        conn.close()

@manage_consumable_bp.route('/get-consumables')
def get_consumables():
    """Return the list of consumables for AJAX requests."""
    conn = get_db_connection()
    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            # Only filter on `is_archived` when the column exists to avoid
            # SQL errors on schemas that don't have that column.
            cur.execute("""
                SELECT COUNT(*) AS cnt
                FROM information_schema.COLUMNS
                WHERE TABLE_SCHEMA = DATABASE()
                  AND TABLE_NAME = 'consumables'
                  AND COLUMN_NAME = 'is_archived'
            """)
            row = cur.fetchone()
            has_is_archived = bool(row and int(row.get('cnt', 0)) > 0)

            sql = """
                SELECT 
                    c.accession_id,
                    c.item_name,
                    c.category,
                    c.brand,
                    c.quantity,
                    c.unit,
                    c.department_id,
                    c.location,
                    c.status,
                    c.description,
                    c.date_added,
                    c.last_updated,
                    c.added_by,
                    d.department_name
                FROM consumables c
                LEFT JOIN departments d ON c.department_id = d.department_id
            """

            if has_is_archived:
                sql += " WHERE COALESCE(c.is_archived, 0) = 0"

            sql += " ORDER BY c.accession_id DESC"

            cur.execute(sql)
            consumables = cur.fetchall()
        return jsonify(consumables)
    finally:
        conn.close()


@manage_consumable_bp.route('/archive-consumable/<int:id>', methods=['POST'])
def archive_consumable(id):
    """Mark a consumable as archived (is_archived=1, deleted_at=NOW()).
    This is a non-destructive archive and will not remove rows.
    """
    conn = get_db_connection()
    is_ajax = request.headers.get('X-Requested-With') == 'XMLHttpRequest'
    try:
        with conn.cursor() as cur:
            # Ensure archive columns exist. If they don't, try to add them
            cur.execute("SELECT COUNT(*) AS cnt FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'consumables' AND COLUMN_NAME = 'is_archived'")
            row = cur.fetchone()
            has_is_archived = bool(row and int(row.get('cnt', 0)) > 0) if isinstance(row, dict) else bool(row and row[0] > 0)

            if not has_is_archived:
                try:
                    cur.execute("ALTER TABLE consumables ADD COLUMN is_archived TINYINT(1) DEFAULT 0, ADD COLUMN deleted_at DATETIME NULL")
                    conn.commit()
                except Exception:
                    # If we cannot alter table, rollback and continue - we'll fallback to setting status
                    conn.rollback()

            # Try to mark archived (non-destructive)
            try:
                # Mark as archived and set status explicitly to ARCHIVED
                cur.execute("UPDATE consumables SET is_archived = 1, deleted_at = NOW(), status = %s WHERE accession_id = %s", ('ARCHIVED', id))
                if cur.rowcount == 0:
                    # No rows updated - maybe accession_id type mismatch, attempt update by casting to string
                    cur.execute("UPDATE consumables SET is_archived = 1, deleted_at = NOW(), status = %s WHERE CAST(accession_id AS CHAR) = %s", ('ARCHIVED', str(id)))

                conn.commit()
                if is_ajax:
                    return jsonify(success=True, message='Consumable archived')
                flash('Consumable archived', 'success')
                return redirect(url_for('manage_inventory.inventory_load', section='consumable'))

            except Exception:
                conn.rollback()
                # Final fallback: set status to ARCHIVED so it no longer shows as active
                try:
                    cur.execute("UPDATE consumables SET status = %s WHERE accession_id = %s", ('ARCHIVED', id))
                    conn.commit()
                    if is_ajax:
                        return jsonify(success=True, message='Consumable set to ARCHIVED')
                    flash('Consumable set to ARCHIVED', 'success')
                    return redirect(url_for('manage_inventory.inventory_load', section='consumable'))
                except Exception as e2:
                    conn.rollback()
                    raise e2

    except Exception as e:
        conn.rollback()
        if is_ajax:
            return jsonify(success=False, error=str(e)), 500
        flash(f'Error archiving consumable: {e}', 'danger')
    finally:
        conn.close()


@manage_consumable_bp.route('/manage_consumable')
def manage_consumable_page():
    """Redirect to the central inventory page for consumables.

    The project uses a unified `manage_inventory` page which already
    renders consumables with pagination and filtering. Redirecting
    here avoids duplicating templates and ensures consumables display
    consistently.
    """
    return redirect(url_for('manage_inventory.inventory_load', section='consumable'))

@manage_consumable_bp.route('/add-consumable', methods=['POST'])
def add_consumable():
    conn = get_db_connection()
    try:
        form = request.form
        item_name = form.get('item_name')
        category = form.get('category')
        brand = form.get('brand')
        quantity = int(form.get('quantity', 1))
        unit = form.get('unit')
        department_id = form.get('department_id')
        location = form.get('location')
        status = form.get('status') or 'Available'
        description = form.get('description')
        date_added = form.get('date_added')
        last_updated = form.get('last_updated')
        added_by = form.get('added_by')

        with conn.cursor() as cur:
            cur.execute("""
                INSERT INTO consumables (
                    item_name, category, brand, quantity, unit, department_id,
                    location, status, description, date_added, last_updated, added_by
                ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """, (
                item_name, category, brand, quantity, unit, department_id,
                location, status, description, date_added, last_updated, added_by
            ))

        conn.commit()

        # Response handling
        if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
            return jsonify({"success": True, "message": "Consumable added successfully!"})
        else:
            flash("Consumable added successfully!", "success")
            return redirect(url_for('manage_inventory.inventory_load', section='consumable'))

    except Exception as e:
        conn.rollback()
        print(f"❌ Error adding consumable: {e}")
        flash("Error adding consumable.", "danger")
        return redirect(url_for('manage_inventory.inventory_load', section='consumable'))

    finally:
        conn.close()

@manage_consumable_bp.route('/update-consumable', methods=['POST'])
def update_consumable():
    conn = get_db_connection()
    try:
        form = request.form
        accession_id = form.get('accession_id')
        if not accession_id:
            flash("Missing consumable ID.", "danger")
            return redirect(url_for('manage_inventory.inventory_load', section='consumable'))

        item_name = form.get('item_name')
        category = form.get('category')
        brand = form.get('brand')
        quantity = int(form.get('quantity', 1))
        unit = form.get('unit')
        department_id = form.get('department_id')
        location = form.get('location')
        status = form.get('status')
        description = form.get('description')
        date_added = form.get('date_added')
        last_updated = form.get('last_updated')
        added_by = form.get('added_by')

        with conn.cursor() as cur:
            cur.execute("""
                UPDATE consumables
                SET item_name=%s,
                    category=%s,
                    brand=%s,
                    quantity=%s,
                    unit=%s,
                    department_id=%s,
                    location=%s,
                    status=%s,
                    description=%s,
                    date_added=%s,
                    last_updated=%s,
                    added_by=%s
                WHERE accession_id=%s
            """, (
                item_name, category, brand, quantity, unit, department_id,
                location, status, description, date_added, last_updated, added_by,
                accession_id
            ))
            conn.commit()

        if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
            return jsonify({"success": True, "message": "Consumable updated successfully!"})
        else:
            flash("Consumable updated successfully!", "success")
            return redirect(url_for('manage_inventory.inventory_load', section='consumable'))

    except Exception as e:
        conn.rollback()
        print(f"❌ Error updating consumable: {e}")
        flash("Error updating consumable.", "danger")
        return redirect(url_for('manage_inventory.inventory_load', section='consumable'))

    finally:
        conn.close()

@manage_consumable_bp.route('/delete-consumable/<int:id>', methods=['POST'])
def delete_consumable(id):
    is_ajax = request.headers.get('X-Requested-With') == 'XMLHttpRequest'
    conn = get_db_connection()
    try:
        with conn.cursor() as cur:
            # Count references in both legacy `consumable_transactions` and the
            # new `consumable_usage` table to decide whether deletion is allowed.
            # Perform two separate queries so we can gracefully handle the case
            # where the `consumable_usage` table does not yet exist.
            cur.execute("SELECT COUNT(*) AS cnt FROM consumable_transactions WHERE accession_id=%s", (id,))
            row_tx = cur.fetchone()
            tx_count_legacy = 0
            if isinstance(row_tx, dict):
                tx_count_legacy = int(row_tx.get('cnt', 0) or 0)
            elif isinstance(row_tx, (list, tuple)):
                tx_count_legacy = int(row_tx[0] if row_tx else 0)

            tx_count_usage = 0
            try:
                cur.execute("SELECT COUNT(*) AS cnt FROM consumable_usage WHERE accession_id=%s", (id,))
                row_usage = cur.fetchone()
                if isinstance(row_usage, dict):
                    tx_count_usage = int(row_usage.get('cnt', 0) or 0)
                elif isinstance(row_usage, (list, tuple)):
                    tx_count_usage = int(row_usage[0] if row_usage else 0)
            except Exception:
                # If the table doesn't exist yet, treat usage count as zero
                tx_count_usage = 0

            tx_count = tx_count_legacy + tx_count_usage

            if tx_count and int(tx_count) > 0:
                message = (
                    "Cannot delete this consumable because it has transaction history. "
                    "You can set it to an inactive status instead."
                )
                if is_ajax:
                    return jsonify(success=False, error=message), 400
                flash(
                    message,
                    "danger",
                )
                return redirect(url_for('manage_inventory.inventory_load', section='consumable'))

            cur.execute("DELETE FROM consumables WHERE accession_id = %s", (id,))
            conn.commit()
        if is_ajax:
            return jsonify(success=True, message='Consumable deleted successfully!')
        flash("Consumable deleted successfully!", "success")
    except pymysql.IntegrityError:
        conn.rollback()
        message = (
            "Cannot delete this consumable because it is referenced by other records. "
            "You can set it to an inactive status instead."
        )
        if is_ajax:
            return jsonify(success=False, error=message), 400
        flash(
            message,
            "danger",
        )
    except Exception as e:
        conn.rollback()
        if is_ajax:
            return jsonify(success=False, error=f"Error deleting consumable: {e}"), 500
        flash(f"Error deleting consumable: {e}", "danger")
    finally:
        conn.close()

    return redirect(url_for('manage_inventory.inventory_load', section='consumable'))

@manage_consumable_bp.route('/get-consumable-by-id/<int:item_id>')
def get_consumable_by_id(item_id):
    """Fetch a single consumable record from the consumables table for editing."""
    conn = get_db_connection()
    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            cur.execute("""
                SELECT 
                    c.accession_id,
                    c.item_name,
                    c.category,
                    c.brand,
                    c.quantity,
                    c.unit,
                    c.department_id,
                    c.location,
                    c.status,
                    c.description,
                    c.date_added,
                    c.last_updated,
                    c.added_by
                FROM consumables c
                WHERE c.accession_id = %s
            """, (item_id,))
            item = cur.fetchone()

        if not item:
            return jsonify({'error': 'Consumable not found'}), 404
        return jsonify(item)

    except Exception as e:
        print(f"❌ Error fetching consumable by ID: {e}")
        return jsonify({'error': 'Database error'}), 500
    finally:
        conn.close()

# ✅ Bulk Update Consumables
@manage_consumable_bp.route('/consumable/bulk-update', methods=['POST'])
def bulk_update_consumables():
    conn = get_db_connection()
    try:
        data = request.get_json()
        consumable_ids = data.get('consumable_ids', [])
        new_status = data.get('new_status')
        
        if not consumable_ids or not new_status:
            return jsonify({'success': False, 'error': 'Missing required parameters'})
        
        with conn.cursor() as cur:
            placeholders = ','.join(['%s'] * len(consumable_ids))
            cur.execute(f"""
                UPDATE devices_full 
                SET status = %s 
                WHERE accession_id IN ({placeholders}) AND device_type = 'Consumable'
            """, [new_status] + consumable_ids)
            conn.commit()
            
        return jsonify({'success': True, 'message': f'Updated {len(consumable_ids)} consumables'})
        
    except Exception as e:
        conn.rollback()
        print(f"❌ Error bulk updating consumables: {e}")
        return jsonify({'success': False, 'error': 'Bulk update failed'})
    finally:
        conn.close()

# ✅ Bulk Mark Checked
@manage_consumable_bp.route('/consumable/bulk-check', methods=['POST'])
def bulk_mark_checked():
    conn = get_db_connection()
    try:
        data = request.get_json()
        consumable_ids = data.get('consumable_ids', [])
        
        if not consumable_ids:
            return jsonify({'success': False, 'error': 'Missing consumable IDs'})
        
        with conn.cursor() as cur:
            placeholders = ','.join(['%s'] * len(consumable_ids))
            cur.execute(f"""
                UPDATE devices_full 
                SET last_checked = CURDATE() 
                WHERE accession_id IN ({placeholders}) AND device_type = 'Consumable'
            """, consumable_ids)
            conn.commit()
            
        return jsonify({'success': True, 'message': f'Marked {len(consumable_ids)} consumables as checked'})
        
    except Exception as e:
        conn.rollback()
        print(f"❌ Error bulk marking consumables: {e}")
        return jsonify({'success': False, 'error': 'Bulk check failed'})
    finally:
        conn.close()


@manage_consumable_bp.route('/export-selected-consumables', methods=['POST'])
def export_selected_consumables():
    data = request.get_json(silent=True) or {}
    consumable_ids = data.get('consumable_ids') or []

    try:
        consumable_ids = [int(item_id) for item_id in consumable_ids]
    except (TypeError, ValueError):
        return jsonify({'error': 'Invalid consumable selection'}), 400

    if not consumable_ids:
        return jsonify({'error': 'No consumables selected'}), 400

    conn = get_db_connection()

    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            placeholders = ','.join(['%s'] * len(consumable_ids))
            cur.execute(
                f"""
                SELECT
                    c.accession_id,
                    c.item_name,
                    c.category,
                    c.brand,
                    c.quantity,
                    c.unit,
                    COALESCE(dep.department_name, '') AS department,
                    c.location,
                    c.status,
                    c.description,
                    c.date_added,
                    c.last_updated,
                    c.added_by
                FROM consumables c
                LEFT JOIN departments dep ON dep.department_id = c.department_id
                WHERE c.accession_id IN ({placeholders})
                ORDER BY c.accession_id
                """,
                tuple(consumable_ids)
            )
            rows = cur.fetchall()

        if not rows:
            return jsonify({'error': 'No matching consumables found for export'}), 404

        df = pd.DataFrame(rows).rename(columns={
            'accession_id': 'ID',
            'item_name': 'Item Name',
            'category': 'Category',
            'brand': 'Brand',
            'quantity': 'Quantity',
            'unit': 'Unit',
            'department': 'Department',
            'location': 'Location',
            'status': 'Status',
            'description': 'Description',
            'date_added': 'Date Added',
            'last_updated': 'Last Updated',
            'added_by': 'Added By',
        })

        output = BytesIO()
        with pd.ExcelWriter(output, engine='openpyxl') as writer:
            df.to_excel(writer, index=False, sheet_name='Selected Consumables')

        output.seek(0)

        return send_file(
            output,
            as_attachment=True,
            download_name='selected_consumables.xlsx',
            mimetype='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
        )

    except Exception as e:
        print(f"❌ Consumable export error: {e}")
        return jsonify({'error': str(e)}), 500

    finally:
        conn.close()


@manage_consumable_bp.route('/import-consumables-excel', methods=['POST'])
def import_consumables_excel():
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

        def clean_value(value):
            if pd.isna(value):
                return None
            if isinstance(value, str):
                value = value.strip()
                return value or None
            if isinstance(value, pd.Timestamp):
                return value.date()
            return value

        def to_int(value, default=None, minimum=None):
            if value is None:
                return default
            try:
                number = int(float(value))
            except (TypeError, ValueError):
                return default
            if minimum is not None:
                number = max(minimum, number)
            return number

        df = df.rename(columns={col: normalize_header(col) for col in df.columns})

        alias_map = {
            "item": "item_name",
            "itemname": "item_name",
            "department_name": "department",
            "dept": "department",
            "qty": "quantity",
            "uom": "unit",
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

        for _, row in df.iterrows():
            item_name = clean_value(row.get("item_name"))
            category = clean_value(row.get("category"))
            brand = clean_value(row.get("brand"))
            quantity = to_int(clean_value(row.get("quantity")), default=1, minimum=0)
            unit = clean_value(row.get("unit"))
            department_id = to_int(clean_value(row.get("department_id")), default=None, minimum=1)
            department_name = clean_value(row.get("department"))
            location = clean_value(row.get("location"))
            status = clean_value(row.get("status")) or "Available"
            description = clean_value(row.get("description"))
            date_added = clean_value(row.get("date_added"))
            last_updated = clean_value(row.get("last_updated"))
            added_by = clean_value(row.get("added_by"))

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

            if department_id:
                cur.execute(
                    """
                    SELECT accession_id
                    FROM consumables
                    WHERE item_name = %s
                      AND COALESCE(category, '') = COALESCE(%s, '')
                      AND COALESCE(brand, '') = COALESCE(%s, '')
                      AND COALESCE(unit, '') = COALESCE(%s, '')
                      AND department_id = %s
                      AND COALESCE(location, '') = COALESCE(%s, '')
                    LIMIT 1
                    """,
                    (item_name, category, brand, unit, department_id, location)
                )
            else:
                cur.execute(
                    """
                    SELECT accession_id
                    FROM consumables
                    WHERE item_name = %s
                      AND COALESCE(category, '') = COALESCE(%s, '')
                      AND COALESCE(brand, '') = COALESCE(%s, '')
                      AND COALESCE(unit, '') = COALESCE(%s, '')
                      AND department_id IS NULL
                      AND COALESCE(location, '') = COALESCE(%s, '')
                    LIMIT 1
                    """,
                    (item_name, category, brand, unit, location)
                )

            existing = cur.fetchone()

            if existing:
                if duplicate_option in {"skip", "ignore"}:
                    skipped += 1
                    continue

                cur.execute(
                    """
                    UPDATE consumables
                    SET category = COALESCE(%s, category),
                        brand = COALESCE(%s, brand),
                        quantity = COALESCE(%s, quantity),
                        unit = COALESCE(%s, unit),
                        department_id = COALESCE(%s, department_id),
                        location = COALESCE(%s, location),
                        status = COALESCE(%s, status),
                        description = COALESCE(%s, description),
                        date_added = COALESCE(%s, date_added),
                        last_updated = COALESCE(%s, last_updated),
                        added_by = COALESCE(%s, added_by)
                    WHERE accession_id = %s
                    """,
                    (
                        category,
                        brand,
                        quantity,
                        unit,
                        department_id,
                        location,
                        status,
                        description,
                        date_added,
                        last_updated,
                        added_by,
                        existing["accession_id"],
                    )
                )
                updated += 1
                continue

            cur.execute(
                """
                INSERT INTO consumables
                (item_name, category, brand, quantity, unit, department_id,
                 location, status, description, date_added, last_updated, added_by)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                """,
                (
                    item_name,
                    category,
                    brand,
                    quantity,
                    unit,
                    department_id,
                    location,
                    status,
                    description,
                    date_added,
                    last_updated,
                    added_by,
                )
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
        print(f"❌ Consumable import error: {e}")
        return jsonify({"success": False, "error": str(e)})

    finally:
        if conn:
            conn.close()


