from flask import Blueprint, render_template, request, redirect, url_for, session, flash
from db import get_db_connection
import bcrypt,json
from datetime import datetime
from werkzeug.security import check_password_hash
from utils.user_activity import log_user_activity
# Blueprint setup
login_bp = Blueprint('login_bp', __name__, url_prefix='/login')


# =============================
# LOGIN ROUTE
# =============================
@login_bp.route('/', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')

        conn = get_db_connection()
        try:
            with conn.cursor() as cursor:
                cursor.execute(
                    "SELECT user_id, username, is_admin, role, password, permissions, is_active FROM users WHERE username=%s",
                    (username,)
                )
                user = cursor.fetchone()
        finally:
            conn.close()

        # Username not found
        if not user:
            flash("Invalid username. Please try again.", "error")
            return redirect(url_for('login_bp.login'))

       # Wrong password check
        if not check_password_hash(user['password'], password):
            flash("Incorrect password. Please try again.", "error")
            return redirect(url_for('login_bp.login'))
        
        if user.get('is_active') == 0:
            flash("Your account is inactive. Please contact the administrator.", "error")
            return redirect(url_for('login_bp.login'))

        # Decode permissions JSON safely
        import json
        permissions = {}
        if user.get('permissions'):
            try:
                permissions = json.loads(user['permissions'])
            except json.JSONDecodeError:
                permissions = {}

        # Save session data
        # Derive role and admin flag (backwards compatible with older rows)
        derived_role = user.get('role') or ('admin' if user.get('is_admin') else 'staff')
        session['user'] = {
            'user_id': user['user_id'],
            'username': user['username'],
            'role': derived_role,
            'is_admin': True if (user.get('is_admin') or derived_role == 'admin') else False,
            'permissions': permissions
        }

        log_user_activity(
            user=session['user'],
            action='Login',
            module='Authentication',
            details='User signed in successfully'
        )

        # Route users with explicit role 'user' to the Submit Ticket page
        user_role = (session['user'].get('role') or '').strip().lower()
        if user_role == 'user':
            return redirect(url_for('submit_ticket_bp.submit_ticket_page'))

        # Default behavior: admins/staff go to dashboard
        return redirect(url_for('dashboard_bp.dashboard_load'))
        # ✅ Handle GET requests here
    return render_template('login.html')


# =============================
# LOGOUT ROUTE
# =============================
@login_bp.route('/logout', methods=['POST'])
def logout():
    user = session.get('user')
    if user:
        log_user_activity(
            user=user,
            action='Logout',
            module='Authentication',
            details='User signed out'
        )
    session.clear()
    return redirect(url_for('login_bp.login'))


# =============================
# LOGIN PAGE (DIRECT ROUTE)
# =============================
@login_bp.route('/login-page')
def qrcode_generator_page():
    """Render login page directly"""
    return render_template('login.html')


# =============================
# MAIN ROUTE (USER DASHBOARD)
# =============================
def main():
    """Main user page after login"""
    if 'user_id' not in session:
        return redirect(url_for('login_bp.login'))
    
    if session.get('is_admin'):
        return redirect(url_for('admin'))

    from userborrow import get_available_devices, get_available_units
    raw_items = get_available_devices()

    items = [
        {
            'id': i['id'],
            'name': i['name'],
            'serial_number': i['serial_number'],
            'department': i['department']
        }
        for i in raw_items
    ]

    units = get_available_units()

    return render_template(
        'main.html',
        username=session.get('username'),
        items=items,
        units=units
    )
