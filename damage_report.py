from flask import Blueprint, jsonify, request, render_template, send_file
import pymysql
from db import get_db_connection
from io import BytesIO
import pandas as pd
from utils.permissions import check_permission

damage_report_bp = Blueprint('damage_report_bp', __name__, template_folder='templates')


# -------------------------------
# 1️⃣ Render Damage Report Page
# -------------------------------
@damage_report_bp.route('/damage-report')
@check_permission('damage_report', 'view')
def damage_report_page():
    """Render the Damage Report HTML page."""
    return render_template('damage_report.html')


@damage_report_bp.route('/get-damage-reports', methods=['GET'])
@check_permission('damage_report', 'view')
def loadDamageReports():

    conn = None
    try:
        conn = get_db_connection()

        # Filters
        name = request.args.get('name', '').strip()
        category = request.args.get('category', '').strip()
        department = request.args.get('department', '').strip()
        severity = request.args.get('severity', '').strip()  # Changed from 'status' to 'severity'
        date_from = request.args.get('date_from', '').strip()
        date_to = request.args.get('date_to', '').strip()

        page = int(request.args.get('page', 1))
        per_page = int(request.args.get('per_page', 10))
        offset = (page - 1) * per_page

        query = """
            SELECT 
                d.accession_id AS id,
                d.item_name AS name,
                'Device' AS category,
                dept.department_name AS department,
                '' AS location,
                d.accountable,
                COALESCE(ddr.damage_type, 'Minor') AS damage_type,
                ddr.description AS damage_description,
                d.acquisition_cost,
                d.date_acquired
            FROM devices_full d
            LEFT JOIN departments dept ON dept.department_id = d.department_id
            LEFT JOIN device_damage_reports ddr ON ddr.accession_id = d.accession_id
            WHERE d.status = 'Damaged'
            UNION ALL

            SELECT 
                p.pcid AS id,
                p.pcname AS name,
                'PC' AS category,
                dept.department_name AS department,
                p.location,
                p.accountable,
                COALESCE(dr.damage_type, 'Minor') AS damage_type,
                dr.description AS damage_description,
                p.acquisition_cost,
                p.date_acquired
            FROM pcinfofull p
            LEFT JOIN departments dept ON dept.department_id = p.department_id
            LEFT JOIN damage_reports dr ON dr.pcid = p.pcid
            WHERE p.status = 'Damaged'
        """

        filters = []
        params = []

        if name:
            filters.append("name LIKE %s")
            params.append(f"%{name}%")
        if category and category.lower() != "all":
            filters.append("category = %s")
            params.append(category)
        if department and department.lower() != "all":
            filters.append("department = %s")
            params.append(department)
        if severity and severity.lower() != "all":
            filters.append("damage_type = %s")
            params.append(severity)
        if date_from:
            filters.append("date_acquired >= %s")
            params.append(date_from)
        if date_to:
            filters.append("date_acquired <= %s")
            params.append(date_to)

        if filters:
            query = f"SELECT * FROM ({query}) AS combined WHERE {' AND '.join(filters)}"

        with conn.cursor(pymysql.cursors.DictCursor) as cursor:
            # ---------- TOTAL COUNT ----------
            count_query = f"SELECT COUNT(*) as total FROM ({query}) as count_table"
            cursor.execute(count_query, params)
            total = cursor.fetchone()["total"]

            # ---------- PAGINATION ----------
            query += " ORDER BY date_acquired DESC LIMIT %s OFFSET %s"
            params_with_pagination = params + [per_page, offset]

            cursor.execute(query, params_with_pagination)
            data = cursor.fetchall()

        total_pages = (total + per_page - 1) // per_page

        return jsonify({
            "data": data,
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
        return jsonify({
            "data": [],
            "pagination": {
                "page": 1,
                "per_page": 10,
                "total": 0,
                "total_pages": 0,
                "has_prev": False,
                "has_next": False
            },
            "error": str(e)
        }), 500
    finally:
        if conn is not None:
            try:
                conn.close()
            except Exception:
                pass


@damage_report_bp.route('/export-damage-reports', methods=['GET'])
@check_permission('damage_report', 'view')
def export_damage_reports():
    """Export filtered damage reports as an Excel workbook."""
    conn = None
    try:
        conn = get_db_connection()

        # Filters
        name = request.args.get('name', '').strip()
        category = request.args.get('category', '').strip()
        department = request.args.get('department', '').strip()
        severity = request.args.get('severity', '').strip()
        date_from = request.args.get('date_from', '').strip()
        date_to = request.args.get('date_to', '').strip()

        query = """
            SELECT 
                d.accession_id AS id,
                d.item_name AS name,
                'Device' AS category,
                dept.department_name AS department,
                '' AS location,
                d.accountable,
                COALESCE(ddr.damage_type, 'Minor') AS damage_type,
                ddr.description AS damage_description,
                d.acquisition_cost,
                d.date_acquired
            FROM devices_full d
            LEFT JOIN departments dept ON dept.department_id = d.department_id
            LEFT JOIN device_damage_reports ddr ON ddr.accession_id = d.accession_id
            WHERE d.status = 'Damaged'
            UNION ALL

            SELECT 
                p.pcid AS id,
                p.pcname AS name,
                'PC' AS category,
                dept.department_name AS department,
                p.location,
                p.accountable,
                COALESCE(dr.damage_type, 'Minor') AS damage_type,
                dr.description AS damage_description,
                p.acquisition_cost,
                p.date_acquired
            FROM pcinfofull p
            LEFT JOIN departments dept ON dept.department_id = p.department_id
            LEFT JOIN damage_reports dr ON dr.pcid = p.pcid
            WHERE p.status = 'Damaged'
        """

        filters = []
        params = []

        if name:
            filters.append("name LIKE %s")
            params.append(f"%{name}%")
        if category and category.lower() != "all":
            filters.append("category = %s")
            params.append(category)
        if department and department.lower() != "all":
            filters.append("department = %s")
            params.append(department)
        if severity and severity.lower() != "all":
            filters.append("damage_type = %s")
            params.append(severity)
        if date_from:
            filters.append("date_acquired >= %s")
            params.append(date_from)
        if date_to:
            filters.append("date_acquired <= %s")
            params.append(date_to)

        if filters:
            query = f"SELECT * FROM ({query}) AS combined WHERE {' AND '.join(filters)}"

        query += " ORDER BY date_acquired DESC"

        with conn.cursor(pymysql.cursors.DictCursor) as cursor:
            cursor.execute(query, params)
            data = cursor.fetchall()

        # Build DataFrame
        df = pd.DataFrame(data)
        if df.empty:
            df = pd.DataFrame(columns=['Item / PC Name','Category','Office / Facility','Location','Accountable','Severity','Damage Description','Acquisition Cost','Date Acquired'])
        else:
            df = df.rename(columns={
                'name': 'Item / PC Name',
                'category': 'Category',
                'department': 'Office / Facility',
                'location': 'Location',
                'accountable': 'Accountable',
                'damage_type': 'Severity',
                'damage_description': 'Damage Description',
                'acquisition_cost': 'Acquisition Cost',
                'date_acquired': 'Date Acquired'
            })

        output = BytesIO()
        with pd.ExcelWriter(output, engine='openpyxl') as writer:
            df.to_excel(writer, index=False, sheet_name='Damage Reports')
        output.seek(0)

        return send_file(output, mimetype="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", download_name="Damage_Reports.xlsx", as_attachment=True)
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        if conn is not None:
            try:
                conn.close()
            except Exception:
                pass