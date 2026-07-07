from db import get_db_connection
from datetime import datetime


def approve_borrow_request(borrow_id):
    """Mark a borrow request as Approved"""
    conn = get_db_connection()
    try:
        with conn.cursor() as cur:
            cur.execute(
                "UPDATE borrow_requests SET status = 'Approved' WHERE borrow_id = %s",
                (borrow_id,)
            )
        conn.commit()
    finally:
        conn.close()


def decline_borrow_request(borrow_id):
    """Mark a borrow request as Invalid"""
    conn = get_db_connection()
    try:
        with conn.cursor() as cur:
            cur.execute(
                "UPDATE borrow_requests SET status = 'Invalid' WHERE borrow_id = %s",
                (borrow_id,)
            )
        conn.commit()
    finally:
        conn.close()


def mark_returned_borrow_request(borrow_id):
    """Mark a borrow request as Returned and set return_date"""
    conn = get_db_connection()
    try:
        with conn.cursor() as cur:
            cur.execute(
                "UPDATE borrow_requests SET status = 'Returned', return_date = NOW() WHERE borrow_id = %s",
                (borrow_id,)
            )
        conn.commit()
    finally:
        conn.close()
