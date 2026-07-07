import os
import sys
import pymysql

# Ensure project root is on sys.path so imports like `db` and `manage_pc` resolve
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from db import get_db_connection
import manage_pc


def main():
    conn = get_db_connection()
    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            parts = manage_pc._existing_pc_part_columns(cur)
            if not parts:
                print("No part columns found in pcinfofull.")
                return

            where_clauses = " OR ".join([f"{p} IS NOT NULL AND TRIM({p}) <> ''" for p in parts])
            cur.execute(f"SELECT pcid, {', '.join(parts)} FROM pcinfofull WHERE ({where_clauses}) LIMIT 1")
            pc = cur.fetchone()
            if not pc:
                print("No PC with populated parts found.")
                return

            pcid = pc.get('pcid')
            old_token = None
            old_part = None
            for p in parts:
                val = pc.get(p)
                if val and str(val).strip():
                    tokens = manage_pc._parse_tokens(val)
                    if tokens:
                        old_token = next(iter(tokens))
                        old_part = p
                        break

            if not old_token:
                print("Could not extract a token from the PC part fields.")
                return

            print(f"Selected PC {pcid} part '{old_part}' token to replace: {old_token}")

            # Find a replacement device (prefer stock items with quantity > 0)
            cur.execute("SELECT accession_id, item_name, quantity, status, serial_no, municipal_serial_no FROM devices_full WHERE COALESCE(quantity, -1) > 0 AND LOWER(COALESCE(status,'')) IN ('available','') LIMIT 1")
            dev = cur.fetchone()
            if not dev:
                cur.execute("SELECT accession_id, item_name, quantity, status, serial_no, municipal_serial_no FROM devices_full WHERE LOWER(COALESCE(status,'')) = 'available' LIMIT 1")
                dev = cur.fetchone()
            if not dev:
                print("No suitable replacement device found in devices_full.")
                return

            new_token = str(dev.get('accession_id') or dev.get('serial_no') or dev.get('municipal_serial_no') or '')
            print(f"Using replacement device accession_id={dev.get('accession_id')} name={dev.get('item_name')}")

            # Print before state
            print('\nBefore changes:')
            cur.execute("SELECT accession_id, quantity, status FROM devices_full WHERE accession_id = %s", (dev.get('accession_id'),))
            d_before = cur.fetchone()
            cur.execute("SELECT accession_id, quantity, status FROM devices_full WHERE serial_no = %s OR municipal_serial_no = %s OR accession_id = %s", (old_token, old_token, old_token))
            old_before = cur.fetchall()
            print('Replacement before:', d_before)
            print('Old token before:', old_before)

            # Perform simulated replace: mark old as Damaged, mark new as IN USE (decrement quantity)
            try:
                manage_pc._mark_device_values_damaged(cur, old_token, exclude_pcid=pcid, performed_by=1)
            except Exception as e:
                print('Error marking old token damaged:', e)

            try:
                manage_pc._mark_device_values_in_use(cur, new_token, performed_by=1)
            except Exception as e:
                print('Error marking new token in use:', e)

            conn.commit()

            # Print after state
            print('\nAfter changes:')
            cur.execute("SELECT accession_id, quantity, status FROM devices_full WHERE accession_id = %s", (dev.get('accession_id'),))
            d_after = cur.fetchone()
            cur.execute("SELECT accession_id, quantity, status FROM devices_full WHERE serial_no = %s OR municipal_serial_no = %s OR accession_id = %s", (old_token, old_token, old_token))
            old_after = cur.fetchall()
            print('Replacement after:', d_after)
            print('Old token after:', old_after)

    finally:
        conn.close()


if __name__ == '__main__':
    main()
