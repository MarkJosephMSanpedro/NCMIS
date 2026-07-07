from flask import Blueprint, render_template, request, redirect, url_for, session, flash, jsonify
import pymysql
from datetime import datetime
from db import get_db_connection
from utils.permissions import check_permission

receive_item_bp = Blueprint('receive_item', __name__)

@receive_item_bp.route('/receive-item')
@check_permission('receive_item', 'view')
def receive_item():
    if 'user' not in session or not session['user'].get('user_id'):
        return redirect(url_for('login_bp.login'))
    
    return render_template('receive_item.html')

@receive_item_bp.route('/get-borrowed-items')
@check_permission('receive_item', 'view')
def get_borrowed_items():
    if 'user' not in session or not session['user'].get('user_id'):
        return jsonify({'error': 'Unauthorized'}), 401
    
    # Pagination parameters
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 10, type=int)
    
    if per_page not in [5, 10, 25, 50]:
        per_page = 10
    
    offset = (page - 1) * per_page
    
    try:
        conn = get_db_connection()
        
        # Get total count
        count_query = """
        SELECT COUNT(*) as total
        FROM borrowed_items bi
        WHERE bi.user_id = %s AND bi.status = 'Borrowed'
        """
        
        with conn.cursor() as cursor:
            cursor.execute(count_query, (session['user']['user_id'],))
            total_items = cursor.fetchone()['total']
        
        # Get items that are currently borrowed by the user (paginated)
        query = """
        SELECT 
            bi.borrow_id,
            bi.item_id,
            bi.item_type,
            bi.borrow_date,
            bi.expected_return_date,
            i.item_name,
            i.item_category,
            i.item_location,
            i.department,
            d.pc_name,
            d.pc_category,
            d.pc_location,
            d.department as pc_department
        FROM borrowed_items bi
        LEFT JOIN inventory i ON bi.item_id = i.item_id AND bi.item_type = 'Device'
        LEFT JOIN pc d ON bi.item_id = d.pc_id AND bi.item_type = 'PC'
        WHERE bi.user_id = %s AND bi.status = 'Borrowed'
        ORDER BY bi.borrow_date DESC
        LIMIT %s OFFSET %s
        """
        
        with conn.cursor() as cursor:
            cursor.execute(query, (session['user']['user_id'], per_page, offset))
            items = cursor.fetchall()
        
        conn.close()
        
        total_pages = (total_items + per_page - 1) // per_page
        
        result = []
        for item in items:
            if item['item_type'] == 'Device':
                result.append({
                    'borrow_id': item['borrow_id'],
                    'item_id': item['item_id'],
                    'item_type': item['item_type'],
                    'item_name': item['item_name'],
                    'category': item['item_category'],
                    'location': item['item_location'],
                    'department': item['department'],
                    'borrow_date': item['borrow_date'].strftime('%Y-%m-%d') if item['borrow_date'] else '',
                    'expected_return_date': item['expected_return_date'].strftime('%Y-%m-%d') if item['expected_return_date'] else ''
                })
            else:  # PC
                result.append({
                    'borrow_id': item['borrow_id'],
                    'item_id': item['item_id'],
                    'item_type': item['item_type'],
                    'item_name': item['pc_name'],
                    'category': item['pc_category'],
                    'location': item['pc_location'],
                    'department': item['pc_department'],
                    'borrow_date': item['borrow_date'].strftime('%Y-%m-%d') if item['borrow_date'] else '',
                    'expected_return_date': item['expected_return_date'].strftime('%Y-%m-%d') if item['expected_return_date'] else ''
                })
        
        return jsonify({
            'items': result,
            'page': page,
            'per_page': per_page,
            'total_items': total_items,
            'total_pages': total_pages
        })
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@receive_item_bp.route('/receive-item-submit', methods=['POST'])
@check_permission('receive_item', 'edit')
def receive_item_submit():
    if 'user' not in session or not session['user'].get('user_id'):
        return jsonify({'error': 'Unauthorized'}), 401
    
    try:
        data = request.get_json()
        borrow_id = data.get('borrow_id')
        item_condition = data.get('item_condition')
        damage_description = data.get('damage_description', '')
        has_damage = data.get('has_damage', False)
        
        if not borrow_id or not item_condition:
            return jsonify({'error': 'Missing required fields'}), 400
        
        conn = get_db_connection()
        
        # Get borrowed item details
        item_query = """
        SELECT bi.item_id, bi.item_type, i.item_name, d.pc_name
        FROM borrowed_items bi
        LEFT JOIN inventory i ON bi.item_id = i.item_id AND bi.item_type = 'Device'
        LEFT JOIN pc d ON bi.item_id = d.pc_id AND bi.item_type = 'PC'
        WHERE bi.borrow_id = %s AND bi.user_id = %s AND bi.status = 'Borrowed'
        """
        
        with conn.cursor() as cursor:
            cursor.execute(item_query, (borrow_id, session['user']['user_id']))
            item = cursor.fetchone()
        
        if not item:
            conn.close()
            return jsonify({'error': 'Item not found or already returned'}), 404
        
        # Update borrowed item status
        update_query = """
        UPDATE borrowed_items 
        SET status = 'Returned', 
            return_date = %s,
            item_condition = %s,
            damage_description = %s
        WHERE borrow_id = %s
        """
        
        with conn.cursor() as cursor:
            cursor.execute(update_query, (
                datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                item_condition,
                damage_description if has_damage else None,
                borrow_id
            ))
        
        # If there's damage, create a damage report
        if has_damage and damage_description:
            damage_query = """
            INSERT INTO damage_reports (
                item_id, item_type, name, category, department, location,
                damage_description, severity, accountable, date_reported, status
            ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """
            
            item_name = item['item_name'] if item['item_type'] == 'Device' else item['pc_name']
            
            # Determine severity based on condition
            severity = 'Minor' if item_condition in ['Good', 'Fair'] else 'Major'
            if item_condition == 'Damaged':
                severity = 'Critical'
            
            with conn.cursor() as cursor:
                cursor.execute(damage_query, (
                    item['item_id'],
                    item['item_type'],
                    item_name,
                    item['item_type'],
                    '',  # department - will be updated based on item
                    '',  # location - will be updated based on item
                    damage_description,
                    severity,
                    session.get('user', {}).get('fullname', 'Unknown'),
                    datetime.now().strftime('%Y-%m-%d'),
                    'Pending'
                ))
        
        # Update item availability
        if item['item_type'] == 'Device':
            with conn.cursor() as cursor:
                cursor.execute("UPDATE inventory SET status = 'Available' WHERE item_id = %s", (item['item_id'],))
        else:
            with conn.cursor() as cursor:
                cursor.execute("UPDATE pc SET status = 'Available' WHERE pc_id = %s", (item['item_id'],))
        
        conn.commit()
        conn.close()
        
        return jsonify({'success': True, 'message': 'Item received successfully'})
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500
