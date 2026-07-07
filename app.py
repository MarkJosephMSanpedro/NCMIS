from flask import render_template, request, redirect, url_for, session, Flask, flash, Blueprint,g
import json
import os

from login import login_bp
from userborrow import userborrow_bp
from qr_functions import qrcode_bp
from manage_user import manage_user_bp
from dashboard import dashboard_bp
from manage_item import manage_item_bp
from archive import archive_bp
from report import report_bp
from manage_pc import manage_pc_bp
from manage_department import manage_department_bp
from manage_inventory import manage_inventory_bp
from manage_consumable import manage_consumable_bp
from notification import notification_bp
# sidebar.get_user_access previously queried the DB on every template render.
# Prefer using session-stored permissions (set at login) or `g.permissions`
# (loaded in `load_user_permissions`) to avoid unnecessary DB calls.
from maintenance import maintenance_bp
from damage_report import damage_report_bp
from receive_item import receive_item_bp
from stock_room import stock
from transaction import transaction_bp
from submit_ticket import submit_ticket_bp
from admin_tickets import admin_tickets_bp
from concern import concern_bp
from ticket_reports import ticket_reports_bp
from activity_log import activity_log_bp
from utils.user_activity import log_user_activity



app = Flask(__name__)
app.secret_key = 'a2f1e4f8f60b4f81a8d32dd0b3c2ce90'
app.config['TEMPLATES_AUTO_RELOAD'] = True
app.config['SEND_FILE_MAX_AGE_DEFAULT'] = 0
app.jinja_env.auto_reload = True
app.register_blueprint(login_bp)
app.register_blueprint(report_bp)
app.register_blueprint(userborrow_bp)
app.register_blueprint(manage_pc_bp)
app.register_blueprint(qrcode_bp)
app.register_blueprint(manage_user_bp)
app.register_blueprint(dashboard_bp)
app.register_blueprint(manage_department_bp)
app.register_blueprint(manage_inventory_bp)
app.register_blueprint(manage_consumable_bp)
app.register_blueprint(notification_bp)
app.register_blueprint(manage_item_bp, url_prefix='/manage_inventory')
app.register_blueprint(maintenance_bp)
app.register_blueprint(damage_report_bp)
app.register_blueprint(receive_item_bp)
app.register_blueprint(stock, url_prefix='/stock_room')
app.register_blueprint(transaction_bp)
app.register_blueprint(submit_ticket_bp)
app.register_blueprint(admin_tickets_bp)
app.register_blueprint(concern_bp)
app.register_blueprint(ticket_reports_bp)
app.register_blueprint(activity_log_bp, url_prefix='/activity-log')
# ...existing code...
app.register_blueprint(archive_bp)
# Context processor to make user access available globally in templates
# ✅ Context processor to make user access available globally in templates
@app.context_processor
def inject_user_access():
    user = session.get('user')
    if not user:
        return {'user_access': {}}  # default empty access if not logged in

    # `load_user_permissions` sets `g.permissions` before each request.
    # Use that when available; otherwise fall back to session-stored permissions.
    return {'user_access': getattr(g, 'permissions', user.get('permissions', {}))}



@app.context_processor
def inject_user_permissions():
    """Make user data and permissions available in all templates"""
    user = session.get('user')
    if user:
        return {
            'permissions': user.get('permissions', {}),
            'is_admin': user.get('is_admin', 0),
            'role': user.get('role', 'staff')
        }
    return {'permissions': {}, 'is_admin': 0}
@app.before_request
def load_user_permissions():
    if 'user' in session:
        user = session['user']
        if isinstance(user.get('permissions'), str):
            try:
                user['permissions'] = json.loads(user['permissions'])
            except json.JSONDecodeError:
                user['permissions'] = {}
        g.permissions = user.get('permissions', {})
    else:
        g.permissions = {}


@app.after_request
def add_no_cache_headers(response):
    # Prevent stale pages/data in browsers after refresh.
    if request.path.startswith('/static/') or response.mimetype in {
        'text/html',
        'application/json',
        'text/css',
        'application/javascript',
    }:
        response.headers['Cache-Control'] = 'no-store, no-cache, must-revalidate, max-age=0'
        response.headers['Pragma'] = 'no-cache'
        response.headers['Expires'] = '0'

    try:
        user = session.get('user')
        tracked_methods = {'POST', 'PUT', 'PATCH', 'DELETE'}
        ignored_endpoints = {'login_bp.login', 'login_bp.logout'}
        endpoint = request.endpoint or ''

        tracked_get_endpoints = {
            'manage_item_bp.filter_devices',
            'manage_pc_bp.filter_pcs',
            'manage_consumable_bp.filter_consumables',
            'report_bp.export_reports',
        }

        endpoint_activity_map = {
            # User management
            'manage_user_bp.activate_user': ('Activate User', 'User Management'),
            'manage_user_bp.deactivate_user': ('Deactivate User', 'User Management'),

            # Item management
            'manage_item_bp.add_device': ('Add Item', 'Item Management'),
            'manage_item_bp.update_device': ('Edit Item', 'Item Management'),
            'manage_item_bp.delete_item': ('Delete Item', 'Item Management'),
            'manage_item_bp.filter_devices': ('Filter', 'Item Management'),

            # PC management
            'manage_pc_bp.add_pcinfofull': ('Add Item', 'PC Management'),
            'manage_pc_bp.update_pcinfofull': ('Edit Item', 'PC Management'),
            'manage_pc_bp.delete_pc': ('Delete Item', 'PC Management'),
            'manage_pc_bp.filter_pcs': ('Filter', 'PC Management'),
            'manage_pc_bp.import_pcs_excel': ('Import File', 'PC Management'),
            'manage_pc_bp.export_selected_pcs': ('Export File', 'PC Management'),

            # Consumables
            'manage_consumable_bp.add_consumable': ('Add Item', 'Consumable Management'),
            'manage_consumable_bp.update_consumable': ('Edit Item', 'Consumable Management'),
            'manage_consumable_bp.delete_consumable': ('Delete Item', 'Consumable Management'),
            'manage_consumable_bp.filter_consumables': ('Filter', 'Consumable Management'),
            'manage_consumable_bp.bulk_mark_checked': ('Mark Selected as Checked', 'Consumable Management'),
            'manage_consumable_bp.bulk_update_consumables': ('Update Selected', 'Consumable Management'),

            # Inventory actions
            'manage_inventory_bp.run_risk_update': ('Update Risk Levels', 'Inventory'),
            'manage_inventory_bp.run_device_risk_update': ('Update Risk Levels', 'Inventory'),
            'manage_inventory_bp.bulk_mark_pc_checked': ('Mark Selected as Checked', 'Inventory'),
            'manage_inventory_bp.bulk_mark_device_checked': ('Mark Selected as Checked', 'Inventory'),
            'manage_inventory_bp.mark_pc_checked': ('Mark as Checked', 'Inventory'),
            'manage_inventory_bp.mark_asset_checked': ('Mark as Checked', 'Inventory'),
            'manage_inventory_bp.bulk_surrender_pcs': ('Surrender Selected', 'Inventory'),
            'manage_inventory_bp.bulk_surrender_devices': ('Surrender Selected', 'Inventory'),
            'manage_inventory_bp.bulk_damaged_pcs': ('Mark Selected as Damaged', 'Inventory'),
            'manage_inventory_bp.bulk_damaged_devices': ('Mark Selected as Damaged', 'Inventory'),
            'manage_inventory_bp.bulk_update_devices': ('Update Selected', 'Inventory'),

            # Reports
            'report_bp.export_reports': ('Export File', 'Reports'),
        }

        is_ajax_request = request.headers.get('X-Requested-With') == 'XMLHttpRequest'
        is_page_view_get = (
            request.method == 'GET'
            and bool(endpoint)
            and response.status_code < 400
            and response.mimetype == 'text/html'
            and not is_ajax_request
        )
        is_tracked_get = request.method == 'GET' and (endpoint in tracked_get_endpoints or is_page_view_get)

        if (
            user
            and (request.method in tracked_methods or is_tracked_get)
            and not request.path.startswith('/static/')
            and endpoint not in ignored_endpoints
        ):
            query_string = request.query_string.decode('utf-8', errors='ignore')
            route_with_query = request.path if not query_string else f"{request.path}?{query_string}"
            module_fallback = (endpoint or 'system').split('.')[0].replace('_bp', '').replace('_', ' ').title()

            if endpoint == 'manage_user_bp.add_or_update_user':
                action = 'Edit User' if (request.form.get('user_id') or '').strip() else 'Add User'
                module_name = 'User Management'
            elif endpoint in endpoint_activity_map:
                action, module_name = endpoint_activity_map[endpoint]
            elif is_page_view_get:
                action = 'View Page'
                module_name = module_fallback
            else:
                module_name = module_fallback
                if request.method == 'GET':
                    action = 'Filter'
                elif request.method == 'POST':
                    action = 'Submit'
                else:
                    action = f"{request.method} Request"

            if action == 'View Page':
                details = f"Visited {route_with_query}"
            else:
                details = f"{request.method} {route_with_query} -> {response.status_code}"

            log_user_activity(
                user=user,
                action=action,
                module=module_name,
                details=details
            )
    except Exception as exc:
        print(f"USER ACTIVITY AUTO-LOG ERROR: {exc}")

    return response

@app.route('/')
def index():
    return redirect(url_for('login_bp.login'))

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    debug_mode = os.environ.get('FLASK_DEBUG', '1').strip().lower() in {'1', 'true', 'yes', 'on'}
    app.run(host='0.0.0.0', port=port, debug=debug_mode)