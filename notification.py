from flask import request, render_template, redirect, url_for, flash, Blueprint, jsonify, session
from db import get_db_connection
import pymysql

notification_bp = Blueprint('notification_bp', __name__)


def add_notification(user_id, action, target_type=None, target_id=None):
    """
    Logs a notification of a user's action.
    """
    conn = get_db_connection()
    try:
        with conn.cursor() as cur:
            cur.execute("""
                INSERT INTO notifications (user_id, action, target_type, target_id)
                VALUES (%s, %s, %s, %s)
            """, (user_id, action, target_type, target_id))
            conn.commit()
    except Exception as e:
        conn.rollback()
        print(f"❌ Notification DB error: {e}")
        raise
    finally:
        conn.close()


@notification_bp.route('/get_notifications', methods=['GET'])
def get_notifications():
    """
    Returns all notifications in JSON format.
    """
    user_id = session.get('user_id')

    conn = get_db_connection()
    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            cur.execute("""
                SELECT n.*, u.username AS user_name
                FROM notifications n
                LEFT JOIN users u ON n.user_id = u.user_id
                ORDER BY n.created_at DESC
                LIMIT 50
            """)
            notifications = cur.fetchall()
            return jsonify(notifications)
    except Exception as e:
        print(f"❌ Error fetching notifications: {e}")
        return jsonify([]), 500
    finally:
        conn.close()


@notification_bp.route('/notifications_modal')
def notifications_modal():
    """
    Render modal partial for notifications.
    """
    return render_template('notifications_modal.html')
