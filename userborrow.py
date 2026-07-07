from flask import Blueprint, render_template, request, redirect, url_for, session, flash
from db import get_db_connection
 
import pymysql
from datetime import datetime 


now = datetime.now()

userborrow_bp = Blueprint('userborrow_bp', __name__, url_prefix='/borrow')

@userborrow_bp.route('/', methods=['GET', 'POST'])
def borrow_page():
    if request.method == 'POST':
        last_name = request.form.get('last_name')
        first_name = request.form.get('first_name')
        middle_initial = request.form.get('middle_initial')
        student_id = request.form.get('student_id')
        reason = request.form.get('reason')
        borrow_date = datetime.now().strftime('%Y-%m-%d')

        # comes from <select name="unit_id" … value="{{ u.accession_id }}">
        accession_id = request.form.get('unit_id')

        if not accession_id:
            flash('Please choose a device unit.')
            return redirect(url_for('userborrow_bp.borrow_page'))

        conn = get_db_connection()
        with conn.cursor() as cur:
            # Insert student if new
            cur.execute("""
                INSERT IGNORE INTO students (student_id, last_name, first_name, middle_initial)
                VALUES (%s, %s, %s, %s)
            """, (student_id, last_name, first_name, middle_initial))

            # Insert borrow request (note: device_id instead of accession_id)
            cur.execute("""
                INSERT INTO borrow_requests
                    (student_id, last_name, first_name, middle_initial,
                     device_id, borrow_date, reason, status)
                VALUES (%s, %s, %s, %s, %s, %s, %s, 'Pending')
            """, (student_id, last_name, first_name, middle_initial,
                  accession_id, borrow_date, reason))

            # Update unit status
            cur.execute("""
                UPDATE devices_units
                SET status='Borrowed'
                WHERE accession_id=%s
            """, (accession_id,))

        conn.commit()
        conn.close()

        flash(f'Request for unit {accession_id} submitted!')
        print(f"DEBUG: Borrow request inserted for student {student_id} on unit {accession_id}")

        return redirect(url_for('userborrow_bp.borrow_page'))

    # GET: load dropdown data
    items = get_available_devices()
    units = get_available_units()
    conn = get_db_connection()
    with conn.cursor() as cur:
        cur.execute("SELECT * FROM students")
        students = cur.fetchall()
    conn.close()

    now = datetime.now()
    return render_template('main.html', items=items, units=units, students=students, now=now)

def get_available_units():
    conn = get_db_connection()
    with conn.cursor(pymysql.cursors.DictCursor) as cur:
        cur.execute("""
            SELECT du.accession_id,
                   du.serial_number AS unit_serial,
                   d.item_name,
                   d.brand_model
            FROM devices_units du
            JOIN devices d ON d.device_id = du.device_id
            WHERE du.status = 'Available'
        """)
        units = cur.fetchall()
    conn.close()
    return units


@userborrow_bp.route('/decline/<int:borrow_id>', methods=['POST'])
def cancel_request(borrow_id):
    conn = get_db_connection()
    with conn.cursor() as cur:
        cur.execute("""
            UPDATE borrow_requests
            SET status='Cancelled'
            WHERE borrow_id=%s AND user_id=%s AND status='Pending'
        """, (borrow_id, session['user_id']))
    conn.commit()
    conn.close()
    flash('Request cancelled')
    return redirect(url_for('userborrow_bp.borrow_page'))

def get_available_devices():
    conn = get_db_connection()
    with conn.cursor(pymysql.cursors.DictCursor) as cur:
        cur.execute("""
            SELECT 
                d.device_id AS id,
                d.item_name AS name,
                d.serial_number,
                dep.department_name AS department
            FROM devices d
            JOIN departments dep ON d.department_id = dep.department_id
            WHERE d.status = 'Available'
        """)
        devices = cur.fetchall()
    conn.close()
    return devices

def get_stock_counts():
    conn = get_db_connection()
    with conn.cursor(pymysql.cursors.DictCursor) as cur:
        cur.execute("""
            SELECT item_name, COUNT(*) AS available_stock
            FROM devices
            WHERE status = 'Available'
            GROUP BY item_name
        """)
        stocks = cur.fetchall()
    conn.close()
    return stocks


@userborrow_bp.route('/return/<int:borrow_id>', methods=['POST'])

def mark_returned_borrow_request(borrow_id,now=now):

    
   
    conn = get_db_connection()
    with conn.cursor() as cur:
        cur.execute("""
            UPDATE borrow_requests
            SET status = 'Returned', return_date = now()
             WHERE borrow_id=%s AND user_id=%s AND status='Approved'
        """, (borrow_id,))
    conn.commit()
    conn.close()
    flash('Item marked as returned.')
    return redirect(url_for('admin'))        
