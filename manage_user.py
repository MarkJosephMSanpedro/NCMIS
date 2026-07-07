import pymysql
import json
from db import get_db_connection
from flask import Blueprint, jsonify, request, render_template, redirect, url_for, flash
from werkzeug.security import generate_password_hash
manage_user_bp = Blueprint('manage_user_bp', __name__, template_folder='templates')


# ========================
# LOAD MANAGE USERS PAGE
# ========================
@manage_user_bp.route('/manage-user')
def manage_user_page():
    """
    Load Manage Users page with pagination.
    """
    # Pagination parameters
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 10, type=int)
    
    # Validate per_page
    if per_page not in [5, 10, 25, 50]:
        per_page = 10
    if page < 1:
        page = 1
    
    conn = get_db_connection()
    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cursor:
            # Get total count
            cursor.execute("SELECT COUNT(*) as total FROM users")
            total_items = cursor.fetchone()['total']

            total_pages = (total_items + per_page - 1) // per_page if total_items else 1
            if total_items and page > total_pages:
                page = total_pages

            offset = (page - 1) * per_page
            
            # Get paginated users (include role)
            cursor.execute("""
                 SELECT 
                user_id,
                username,
                first_name,
                middle_name,
                last_name,
                email,
                is_admin,
                role,
                is_active,
                permissions,
                created_at
                FROM users
                ORDER BY faculty_name
                LIMIT %s OFFSET %s
            """, (per_page, offset))
            users = cursor.fetchall()
        
        return render_template('manage_user.html', 
                             users=users,
                             page=page,
                             per_page=per_page,
                             total_items=total_items,
                             total_pages=total_pages)
    finally:
        conn.close()


# ========================
# GET USERS (JSON)
# ========================
@manage_user_bp.route('/get-users')
def get_users():
    """
    Fetch all users (for API/AJAX use).
    """
    conn = get_db_connection()
    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cursor:
            cursor.execute("""
                SELECT 
                    user_id,
                    username,
                    first_name,
                    middle_name,
                    last_name,
                    email,
                    is_admin,
                    role,
                    is_active,
                    created_at,
                    updated_at
                FROM users
                ORDER BY faculty_name
            """)
            users = cursor.fetchall()
            return jsonify(users)
    finally:
        conn.close()


# ========================
# ADD OR UPDATE USER
# ========================

@manage_user_bp.route('/add-or-update-user', methods=['POST'])
def add_or_update_user():
    data = request.form
    user_id = data.get('user_id')
    first_name = data.get('first_name', '').strip()
    middle_name = data.get('middle_name', '').strip()
    last_name = data.get('last_name', '').strip()
    username = data.get('username', '').strip()
    email = data.get('email', '').strip()
    password = data.get('password', '')
    # Read role and derive is_admin for backward compatibility
    role = (data.get('role') or 'staff').strip().lower()
    allowed_roles = {'staff', 'technician', 'dept_head', 'admin'}
    if role not in allowed_roles:
        role = 'staff'
    is_admin = 1 if role == 'admin' else 0
    new_password = data.get('new_password', '').strip()
    confirm_password = data.get('confirm_password', '').strip()
    permissions = data.getlist('permissions')

    # Build structured JSON for permissions
    perm_data = {
        "dashboard": {"view": "dashboard_view" in permissions, "edit": "dashboard_edit" in permissions},
        "inventory": {"view": "inventory_view" in permissions, "edit": "inventory_edit" in permissions},
        "transaction": {"view": "transaction_view" in permissions, "add": "transaction_add" in permissions, "edit": "transaction_edit" in permissions},
        "submit_ticket": {"view": "submit_ticket_view" in permissions, "add": "submit_ticket_add" in permissions},
        "qrlist": {"view": "qrlist_view" in permissions, "edit": "qrlist_edit" in permissions},
        "report": {"view": "report_view" in permissions, "edit": "report_edit" in permissions},
        "dept": {
            "view": "dept_view" in permissions,
            "edit": "dept_edit" in permissions,
            "delete": "dept_delete" in permissions
        },
        "damage_report": {"view": "damage_report_view" in permissions, "edit": "damage_report_edit" in permissions},
        "receive_item": {"view": "receive_item_view" in permissions, "edit": "receive_item_edit" in permissions},
        "activity_log": {"view": "activity_log_view" in permissions, "edit": "activity_log_edit" in permissions},
        "manage_user": {"view": "manage_user_view" in permissions, "edit": "manage_user_edit" in permissions},
        "maintenance": {"view": "maintenance_view" in permissions, "edit": "maintenance_edit" in permissions},
        "stock_room": {"view": "stock_room_view" in permissions, "edit": "stock_room_edit" in permissions}
    }

    if not first_name or not last_name or not username or not email:
        return jsonify({"error": "Missing required fields"}), 400

    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            email_check_query = """
                SELECT user_id
                FROM users
                WHERE LOWER(email) = LOWER(%s)
            """
            email_check_params = [email]

            if user_id:
                email_check_query += " AND user_id <> %s"
                email_check_params.append(user_id)

            email_check_query += " LIMIT 1"
            cursor.execute(email_check_query, tuple(email_check_params))
            duplicate_email_row = cursor.fetchone()

            if duplicate_email_row:
                if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
                    return jsonify({"error": "Email already exists. Please use a different email."}), 409

                flash("Email already exists. Please use a different email.", "error")
                return redirect(url_for('manage_user_bp.manage_user_page'))

            if user_id:  # Update existing user
                if new_password:
                    if new_password != confirm_password:
                        return jsonify({"error": "Passwords do not match"}), 400
                    hashed_pw = generate_password_hash(new_password)
                    sql = """
                        UPDATE users
                        SET first_name=%s, middle_name=%s, last_name=%s,
                            username=%s, email=%s, password=%s, is_admin=%s,
                            role=%s, permissions=%s, updated_at=NOW()
                        WHERE user_id=%s
                    """
                    cursor.execute(sql, (
                        first_name, middle_name, last_name,
                        username, email, hashed_pw, is_admin,
                        role, json.dumps(perm_data), user_id
                    ))
                else:
                    sql = """
                        UPDATE users
                        SET first_name=%s, middle_name=%s, last_name=%s,
                            username=%s, email=%s, is_admin=%s,
                            role=%s, permissions=%s, updated_at=NOW()
                        WHERE user_id=%s
                    """
                    cursor.execute(sql, (
                        first_name, middle_name, last_name,
                        username, email, is_admin,
                        role, json.dumps(perm_data), user_id
                    ))

            else:  # Add new user
                hashed_pw = generate_password_hash(password)
                sql = """
                    INSERT INTO users 
                    (first_name, middle_name, last_name, username, email, password, is_admin, role, permissions, is_active, created_at, updated_at)
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, 1, NOW(), NOW())
                """
                cursor.execute(sql, (
                    first_name, middle_name, last_name,
                    username, email, hashed_pw,
                    is_admin, role, json.dumps(perm_data)
                ))

        conn.commit()
        return redirect(url_for('manage_user_bp.manage_user_page'))
    finally:
        conn.close()

# ========================
# DEACTIVATE USER
# ========================
@manage_user_bp.route('/deactivate-user', methods=['POST'])
def deactivate_user():
    """
    Soft deactivate a user (set is_active = 0)
    """
    user_id = request.form.get('user_id')

    if not user_id:
        return jsonify({"error": "Missing user_id"}), 400

    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("UPDATE users SET is_active = 0, updated_at = NOW() WHERE user_id = %s", (user_id,))
        conn.commit()
        return redirect(url_for('manage_user_bp.manage_user_page'))
    finally:
        conn.close()


# ========================
# ACTIVATE USER
# ========================
@manage_user_bp.route('/activate-user', methods=['POST'])
def activate_user():
    """
    Reactivate a user (set is_active = 1)
    """
    user_id = request.form.get('user_id')

    if not user_id:
        return jsonify({"error": "Missing user_id"}), 400

    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("UPDATE users SET is_active = 1, updated_at = NOW() WHERE user_id = %s", (user_id,))
        conn.commit()
        return redirect(url_for('manage_user_bp.manage_user_page'))
    finally:
        conn.close()



