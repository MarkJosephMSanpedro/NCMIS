from db import get_db_connection
from datetime import date,datetime
import pymysql

def run_inventory_auto_check():
    conn = get_db_connection()
    today = date.today()

    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            # Fetch all PCs
            cur.execute("SELECT * FROM pcinfofull")
            pcs = cur.fetchall()

            for pc in pcs:
                old_status = pc["status"]
                old_risk = pc["risk_level"]

                # Compute new health and risk
                health, risk = calculate_health_and_risk(pc)

                # Determine new status if risk is High
                new_status = old_status
                if risk == "High":
                    new_status = "Needs Checking"

                # Update PC info
                cur.execute("""
                    UPDATE pcinfofull
                    SET health_score = %s,
                        risk_level = %s,
                        status = %s
                    WHERE pcid = %s
                """, (health, risk, new_status, pc["pcid"]))

                # Insert into maintenance_history ONLY if something changed
                if old_status != new_status or old_risk != risk:
                    cur.execute("""
                        INSERT INTO maintenance_history
                        (pcid, asset_type, asset_id, action, old_status, new_status,
                        risk_level, health_score, performed_by, remarks)
                        VALUES (%s, 'PC', %s, %s, %s, %s, %s, %s, %s, %s)
                    """, (
                        pc["pcid"],
                        pc["pcid"],
                        "Auto Risk Update",
                        old_status,
                        new_status,
                        risk,
                        health,
                        "System",
                        f"Auto-updated on {today}"
                    ))

        conn.commit()
        print("Inventory auto-check and logging executed successfully")

    except Exception as e:
        conn.rollback()
        print("Auto-check failed:", e)

    finally:
        conn.close()

def parse_date(value):
    if not value:
        return None
    if isinstance(value, date):
        return value
    if isinstance(value, str):
        try:
            return datetime.strptime(value, "%Y-%m-%d").date()
        except ValueError:
            return None
    return None


def normalize_interval_days(raw_value, default_days=30):
    """
    Normalize maintenance interval to days.

    Backward compatibility:
    - Existing rows may store small year-like values (e.g., 5) in
      maintenance_interval_days due to older UI labeling.
    - Values below 365 are interpreted as years and converted to days.
    - Values 365+ are already treated as day counts.
    """
    try:
        interval = int(raw_value or default_days)
    except (TypeError, ValueError):
        interval = default_days

    interval = max(interval, 1)
    if interval < 365:
        interval *= 365

    return interval


def calculate_health_and_risk(pc):
    today = date.today()
    status = (pc.get("status") or "").strip()
    status_key = status.lower()

    if status_key in {"damaged", "damage", "unusable"}:
        return 0, "High"

    interval = normalize_interval_days(pc.get("maintenance_interval_days"), default_days=30)

    last_checked = parse_date(pc.get("last_checked"))
    date_acquired = parse_date(pc.get("date_acquired"))
    if last_checked:
        elapsed_days = max(0, (today - last_checked).days)
    else:
        baseline_date = date_acquired or today
        elapsed_days = max(0, (today - baseline_date).days)

    duration_percent = (elapsed_days / interval) * 100
    score = round(max(0.0, 100.0 - duration_percent))

    score = max(0, min(100, int(score)))

    if duration_percent >= 100:
        risk = "High"
    elif duration_percent >= 80:
        risk = "Medium"
    else:
        risk = "Low"

    if status_key == "needs checking" and risk == "Low":
        risk = "Medium"

    return score, risk