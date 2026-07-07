import pymysql
from flask import Blueprint, render_template, request, jsonify
from db import get_db_connection

manage_department_bp = Blueprint('manage_department_bp', __name__, template_folder='templates')

EXPECTED_DEPARTMENT_COLUMNS = {
    'max_pc_allowed': "ADD COLUMN max_pc_allowed INT UNSIGNED NOT NULL DEFAULT 0 AFTER category",
}


def _sync_departments_schema(conn):
    with conn.cursor(pymysql.cursors.DictCursor) as cursor:
        cursor.execute("SHOW COLUMNS FROM departments")
        existing_columns = {row['Field'] for row in cursor.fetchall()}

        for column_name, alter_sql in EXPECTED_DEPARTMENT_COLUMNS.items():
            if column_name not in existing_columns:
                cursor.execute(f"ALTER TABLE departments {alter_sql}")


def _sync_department_fk_schema(conn):
    """
    Make `department_id` columns nullable where possible by inspecting
    information_schema. This is a best-effort, non-fatal operation used
    to make deleting departments safer.
    """
    with conn.cursor(pymysql.cursors.DictCursor) as cursor:
        cursor.execute("""
            SELECT TABLE_NAME, COLUMN_TYPE, IS_NULLABLE
            FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE() AND COLUMN_NAME = 'department_id'
        """)
        rows = cursor.fetchall() or []

        for row in rows:
            table = row.get('TABLE_NAME') or row.get('table_name')
            is_nullable = (row.get('IS_NULLABLE') or row.get('is_nullable') or '').upper()
            column_type = row.get('COLUMN_TYPE') or row.get('column_type')

            if not table or table.lower() == 'departments':
                continue

            if is_nullable == 'NO' and column_type:
                try:
                    cursor.execute(f"ALTER TABLE `{table}` MODIFY COLUMN `department_id` {column_type} NULL DEFAULT NULL")
                except Exception as exc:
                    # Non-fatal; log and continue
                    print(f"Warning: could not alter {table}.department_id to NULL: {exc}")


def ensure_departments_schema(conn=None):
    created_local_conn = False

    if conn is None:
        conn = get_db_connection()
        created_local_conn = True

    try:
        _sync_departments_schema(conn)
        _sync_department_fk_schema(conn)
        conn.commit()
    finally:
        if created_local_conn:
            conn.close()

# -----------------------------
# LOAD DEPARTMENT PAGE
# -----------------------------
@manage_department_bp.route('/manage-department')
def manage_department_page():
    return render_template('manage_department.html')


# -----------------------------
# FETCH ALL DEPARTMENTS (AJAX)
# -----------------------------
@manage_department_bp.route('/get-departments')
def get_departments():
    conn = get_db_connection()
    try:
        ensure_departments_schema(conn)
        with conn.cursor(pymysql.cursors.DictCursor) as cursor:
            # Determine whether archive columns exist to avoid SQL errors
            try:
                cursor.execute("SELECT COUNT(*) AS cnt FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'pcinfofull' AND COLUMN_NAME = 'is_archived'")
                pcnt = cursor.fetchone()
                has_p_is_arch = bool(pcnt and (int(pcnt.get('cnt', 0)) if isinstance(pcnt, dict) else pcnt[0] > 0))
            except Exception:
                has_p_is_arch = False

            try:
                cursor.execute("SELECT COUNT(*) AS cnt FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'devices_full' AND COLUMN_NAME = 'is_archived'")
                dcnt = cursor.fetchone()
                has_d_is_arch = bool(dcnt and (int(dcnt.get('cnt', 0)) if isinstance(dcnt, dict) else dcnt[0] > 0))
            except Exception:
                has_d_is_arch = False

            # Use COALESCE to safely handle schemas without is_archived column
            p_join_arch = 'AND COALESCE(p.is_archived, 0) = 0' if has_p_is_arch else ''
            df_join_arch = 'AND COALESCE(df.is_archived, 0) = 0' if has_d_is_arch else ''

            # Aggregate PC and device counts in separate subqueries to avoid
            # cross-join multiplication when both tables are LEFT JOINed.
            cursor.execute(f"""
                SELECT
                    d.department_id,
                    d.department_name,
                    d.category,
                    COALESCE(d.max_pc_allowed, 0) AS max_pc_allowed,
                    COALESCE(pc_agg.pc_count, 0) AS pc_count,
                    COALESCE(df_agg.device_count, 0) AS device_count
                FROM departments d
                LEFT JOIN (
                    SELECT p.department_id, COALESCE(COUNT(DISTINCT p.pcid), 0) AS pc_count
                    FROM pcinfofull p
                    WHERE 1=1 {p_join_arch} AND LOWER(COALESCE(p.status, '')) != 'surrendered'
                    GROUP BY p.department_id
                ) pc_agg ON pc_agg.department_id = d.department_id
                LEFT JOIN (
                    SELECT df.department_id, COALESCE(SUM(df.quantity), 0) AS device_count
                    FROM devices_full df
                    WHERE 1=1 {df_join_arch} AND LOWER(COALESCE(df.status, '')) != 'surrendered'
                    GROUP BY df.department_id
                ) df_agg ON df_agg.department_id = d.department_id
                ORDER BY d.department_name
            """)
            return jsonify(cursor.fetchall())
    finally:
        conn.close()


# -----------------------------
# FETCH PCS FOR ONE DEPARTMENT (AJAX)
# -----------------------------
@manage_department_bp.route('/get-department-pcs/<int:department_id>')
def get_department_pcs(department_id):
    conn = get_db_connection()
    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cursor:
            # Determine if pcinfofull has is_archived
            try:
                cursor.execute("SELECT COUNT(*) AS cnt FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'pcinfofull' AND COLUMN_NAME = 'is_archived'")
                _pc_row = cursor.fetchone()
                _has_pc_arch = bool(_pc_row and (int(_pc_row.get('cnt', 0)) if isinstance(_pc_row, dict) else _pc_row[0] > 0))
            except Exception:
                _has_pc_arch = False

            pc_where_arch = 'AND COALESCE(p.is_archived, 0) = 0' if _has_pc_arch else ''

            cursor.execute(f"""
                SELECT
                    p.pcid,
                    p.pcname,
                    p.serial_no,
                    p.municipal_serial_no,
                    p.location,
                    p.status,
                    p.quantity
                FROM pcinfofull p
                WHERE p.department_id = %s {pc_where_arch} AND LOWER(COALESCE(p.status, '')) != 'surrendered'
                ORDER BY p.pcname ASC, p.pcid ASC
            """, (department_id,))
            return jsonify(cursor.fetchall())
    finally:
        conn.close()


# -----------------------------
# FETCH DEVICES FOR ONE DEPARTMENT (AJAX)
# -----------------------------
@manage_department_bp.route('/get-department-devices/<int:department_id>')
def get_department_devices(department_id):
    conn = get_db_connection()
    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cursor:
            # Determine if devices_full has is_archived
            try:
                cursor.execute("SELECT COUNT(*) AS cnt FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'devices_full' AND COLUMN_NAME = 'is_archived'")
                _d_row = cursor.fetchone()
                _has_df_arch = bool(_d_row and (int(_d_row.get('cnt', 0)) if isinstance(_d_row, dict) else _d_row[0] > 0))
            except Exception:
                _has_df_arch = False

            df_where_arch = 'AND COALESCE(df.is_archived, 0) = 0' if _has_df_arch else ''

            cursor.execute(f"""
                SELECT
                    df.accession_id,
                    df.item_name,
                    df.brand_model,
                    df.serial_no,
                    df.municipal_serial_no,
                    df.quantity,
                    df.device_type,
                    df.status
                FROM devices_full df
                WHERE df.department_id = %s {df_where_arch} AND LOWER(COALESCE(df.status, '')) != 'surrendered'
                ORDER BY df.item_name ASC, df.accession_id ASC
            """, (department_id,))
            return jsonify(cursor.fetchall())
            return jsonify(cursor.fetchall())
    finally:
        conn.close()


# -----------------------------
# ADD NEW DEPARTMENT (AJAX)
# -----------------------------
@manage_department_bp.route('/add-department', methods=['POST'])
def add_department():
    data = request.get_json(silent=True) or {}
    department_name = (data.get('department_name') or '').strip()
    category = (data.get('category') or '').strip()
    raw_max_pc_allowed = data.get('max_pc_allowed')

    try:
        max_pc_allowed = int(raw_max_pc_allowed)
    except (TypeError, ValueError):
        return jsonify({'error': 'A valid PC limit is required'}), 400

    if not department_name or not category:
        return jsonify({'error': 'Department name, category, and PC limit are required'}), 400
    if max_pc_allowed < 0:
        return jsonify({'error': 'PC limit must be 0 or higher'}), 400

    conn = get_db_connection()
    try:
        ensure_departments_schema(conn)
        with conn.cursor() as cursor:
            cursor.execute(
                "INSERT INTO departments (department_name, category, max_pc_allowed) VALUES (%s, %s, %s)",
                (department_name, category, max_pc_allowed)
            )
            conn.commit()

        return jsonify({'message': 'Office/Facility added successfully'}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        conn.close()


@manage_department_bp.route('/update-department/<int:id>', methods=['PUT'])
def update_department(id):
    data = request.get_json(silent=True) or {}
    department_name = (data.get('department_name') or '').strip()
    category = (data.get('category') or '').strip()
    raw_max_pc_allowed = data.get('max_pc_allowed')

    try:
        max_pc_allowed = int(raw_max_pc_allowed)
    except (TypeError, ValueError):
        return jsonify({'error': 'A valid PC limit is required'}), 400

    if not department_name or not category:
        return jsonify({'error': 'Department name, category, and PC limit are required'}), 400
    if max_pc_allowed < 0:
        return jsonify({'error': 'PC limit must be 0 or higher'}), 400

    conn = get_db_connection()
    try:
        ensure_departments_schema(conn)
        with conn.cursor() as cursor:
            cursor.execute(
                "UPDATE departments SET department_name = %s, category = %s, max_pc_allowed = %s WHERE department_id = %s",
                (department_name, category, max_pc_allowed, id)
            )
            conn.commit()

        return jsonify({'message': 'Office/Facility updated successfully'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        conn.close()


@manage_department_bp.route('/delete-department/<int:id>', methods=['DELETE'])
def delete_department(id):
    conn = get_db_connection()
    try:
        # Make sure FK columns are nullable where possible (best-effort)
        ensure_departments_schema(conn)

        # Discover all tables with a department_id column
        with conn.cursor(pymysql.cursors.DictCursor) as cursor:
            cursor.execute("""
                SELECT TABLE_NAME, COLUMN_TYPE, IS_NULLABLE
                FROM information_schema.COLUMNS
                WHERE TABLE_SCHEMA = DATABASE() AND COLUMN_NAME = 'department_id'
            """)
            referencers = cursor.fetchall() or []

        errors = []
        with conn.cursor() as cursor:
            for ref in referencers:
                table = (ref.get('TABLE_NAME') or ref.get('table_name') or '').strip()
                if not table or table.lower() == 'departments':
                    continue

                try:
                    cursor.execute(f"UPDATE `{table}` SET department_id = NULL WHERE department_id = %s", (id,))
                except Exception:
                    # If update failed (column NOT NULL), try altering column type to allow NULL then update
                    column_type = ref.get('COLUMN_TYPE') or ref.get('column_type')
                    if column_type:
                        try:
                            cursor.execute(f"ALTER TABLE `{table}` MODIFY COLUMN `department_id` {column_type} NULL DEFAULT NULL")
                            cursor.execute(f"UPDATE `{table}` SET department_id = NULL WHERE department_id = %s", (id,))
                        except Exception as e2:
                            errors.append(f"{table}: {e2}")
                    else:
                        errors.append(f"{table}: failed to clear references and column type unknown")

            if errors:
                conn.rollback()
                return jsonify({'error': f'Could not clear department references: {errors}'}), 500

            cursor.execute("DELETE FROM departments WHERE department_id = %s", (id,))
            conn.commit()

        return jsonify({'message': 'Office/Facility deleted successfully'})
    except pymysql.err.IntegrityError:
        return jsonify({'error': 'Cannot delete: this office/facility still has linked records. Please try again or contact support.'}), 409
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        conn.close()
