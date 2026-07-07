from flask import Blueprint, render_template, request
from db import get_db_connection
import pymysql

maintenance_bp = Blueprint(
    "maintenance_bp",
    __name__,
    url_prefix="/maintenance"
)

@maintenance_bp.route("/history")
def maintenance_history_page():
    # Pagination parameters
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 10, type=int)
    
    # Validate per_page
    if per_page not in [5, 10, 25, 50]:
        per_page = 10
    
    offset = (page - 1) * per_page
    
    conn = get_db_connection()
    cur = conn.cursor(pymysql.cursors.DictCursor)
 
    # Get total count
    cur.execute("SELECT COUNT(*) as total FROM maintenance_history")
    total_items = cur.fetchone()['total']
    
    # Get paginated records
    cur.execute("""
    SELECT
        mh.performed_at,
        mh.asset_type,
        UPPER(TRIM(mh.asset_type)) AS asset_type_key,
        mh.asset_id,
        mh.action,
        mh.old_status,
        mh.new_status,
        mh.risk_level,
        CASE
            WHEN LOWER(TRIM(mh.new_status)) IN ('damaged', 'damage', 'unusable') THEN 'High'
            WHEN mh.risk_level IS NULL OR TRIM(mh.risk_level) = '' THEN '--'
            ELSE mh.risk_level
        END AS effective_risk_level,
        CASE
            WHEN LOWER(TRIM(mh.new_status)) IN ('damaged', 'damage', 'unusable') THEN 0
            WHEN COALESCE(pc.maintenance_interval_days, df.maintenance_interval_days) IS NULL
                 OR COALESCE(pc.maintenance_interval_days, df.maintenance_interval_days) <= 0 THEN NULL
            WHEN COALESCE(pc.maintenance_interval_days, df.maintenance_interval_days) >= 365
                THEN GREATEST(1, ROUND(COALESCE(pc.maintenance_interval_days, df.maintenance_interval_days) / 365))
            ELSE ROUND(COALESCE(pc.maintenance_interval_days, df.maintenance_interval_days))
        END AS duration_years,
        mh.health_score,
        mh.performed_by,
        mh.remarks,
        CASE
            WHEN UPPER(TRIM(mh.asset_type)) = 'PC' THEN pc.pcname
            WHEN UPPER(TRIM(mh.asset_type)) = 'DEVICE' THEN df.item_name
            ELSE NULL
        END AS asset_name
    FROM maintenance_history mh
    LEFT JOIN pcinfofull pc
        ON UPPER(TRIM(mh.asset_type)) = 'PC'
       AND mh.asset_id = pc.pcid
    LEFT JOIN devices_full df
        ON UPPER(TRIM(mh.asset_type)) = 'DEVICE'
       AND mh.asset_id = df.accession_id
    ORDER BY mh.performed_at DESC
    LIMIT %s OFFSET %s
""", (per_page, offset))
        
    records = cur.fetchall()
    conn.close()
    
    # Calculate total pages
    total_pages = (total_items + per_page - 1) // per_page
    
    return render_template(
        "maintenance_history1.html",
        records=records,
        page=page,
        per_page=per_page,
        total_items=total_items,
        total_pages=total_pages
    )
