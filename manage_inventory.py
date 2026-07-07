from flask import Blueprint, render_template, flash, jsonify,request
from db import get_db_connection
import pymysql
from datetime import date
from inventory_auto_check import calculate_health_and_risk, normalize_interval_days, parse_date

 

 

manage_inventory_bp = Blueprint('manage_inventory', __name__, template_folder='templates')

ALLOWED_PER_PAGE = {5, 10, 25, 50}
DEFAULT_PER_PAGE = 10

@manage_inventory_bp.route('/manage_inventory')
def inventory_load():
    """Load Manage Inventory with pagination for devices."""
    page = _normalize_page(request.args.get("page", 1, type=int))
    item_page = _normalize_page(request.args.get("item_page", 1, type=int))
    consumable_page = _normalize_page(request.args.get("consumable_page", 1, type=int))
    surrendered_page = _normalize_page(request.args.get("surrendered_page", 1, type=int))
    surrendered_item_page = _normalize_page(request.args.get("surrendered_item_page", 1, type=int))
    per_page = _normalize_per_page(request.args.get("per_page", DEFAULT_PER_PAGE, type=int))
    surrendered_per_page = _normalize_per_page(
        request.args.get("surrendered_per_page", per_page, type=int)
    )
    surrendered_item_per_page = _normalize_per_page(
        request.args.get("surrendered_item_per_page", per_page, type=int)
    )
    section = request.args.get("section", "pc")
    
    # Get filter parameters
    department_id = request.args.get('department_id')
    status = request.args.get('status')
    accountable = request.args.get('accountable')
    serial_no = request.args.get('serial_no')
    item_name = request.args.get('item_name')
    brand_model = request.args.get('brand_model')
    device_type = request.args.get('device_type')
    date_from = request.args.get('date_from')
    date_to = request.args.get('date_to')
    search = request.args.get('search')
    
    pc_filters = _get_pc_filters(request.args)

    # PCs
    pc_list, pc_total, pc_pages, page = get_pc_list_paginated(page, per_page, pc_filters)
    # Surrendered PCs (separate list)
    surrendered_pc_list, surrendered_total, surrendered_pages, surrendered_page = get_surrendered_pc_list_paginated(
        surrendered_page,
        surrendered_per_page,
    )
    # Surrendered devices/items
    surrendered_device_list, surrendered_item_total, surrendered_item_pages, surrendered_item_page = get_surrendered_device_list_paginated(
        surrendered_item_page,
        surrendered_item_per_page,
    )
    
    # Check if we have filter parameters for devices
    if any([department_id, status, accountable, serial_no, item_name, brand_model, device_type, date_from, date_to]) or search:
        item_list, item_total, item_pages, item_page = get_filtered_item_list_paginated(
            item_page, per_page, department_id, status, accountable, serial_no, 
            item_name, brand_model, device_type, date_from, date_to, search
        )
    else:
        item_list, item_total, item_pages, item_page = get_item_list_paginated(item_page, per_page)
     
    # Consumables (paginated)
    consumables, consumable_total, consumable_pages, consumable_page = get_consumables_list_paginated(
        page=consumable_page,
        per_page=per_page,
        department_id=department_id,
        status=status,
        accountable=accountable,
        item_name=item_name,
        brand_model=brand_model,
        date_from=date_from,
        date_to=date_to,
        search=search
    )
    
    # Load departments for filters
    departments = get_departments_list()
     
    if pc_list is None or item_list is None:
        flash("Error loading data. Please try again.", "danger")

    return render_template(
        'manage_inventory.html',
        pc_list=pc_list,
        surrendered_pc_list=surrendered_pc_list,
        surrendered_device_list=surrendered_device_list,
        item_list=item_list,
        consumables=consumables,
        departments=departments,

        page=page,
        item_page=item_page,
        consumable_page=consumable_page,
        surrendered_page=surrendered_page,
        surrendered_item_page=surrendered_item_page,
        per_page=per_page,
        surrendered_per_page=surrendered_per_page,
        surrendered_item_per_page=surrendered_item_per_page,
        section=section,

        pc_total_items=pc_total,
        pc_total_pages=pc_pages,
        surrendered_total_items=surrendered_total,
        surrendered_total_pages=surrendered_pages,
        surrendered_item_total_items=surrendered_item_total,
        surrendered_item_total_pages=surrendered_item_pages,

        total_items=item_total,
        total_pages=item_pages,

        consumable_total_items=consumable_total,
        consumable_total_pages=consumable_pages
    )

def _normalize_page(value, default=1):
    try:
        page = int(value)
    except (TypeError, ValueError):
        page = default
    return max(1, page)


def _normalize_per_page(value):
    try:
        per_page = int(value)
    except (TypeError, ValueError):
        per_page = DEFAULT_PER_PAGE
    return per_page if per_page in ALLOWED_PER_PAGE else DEFAULT_PER_PAGE


def _clamp_page(page, total_pages):
    if total_pages <= 0:
        return 1
    return min(max(1, page), total_pages)


def _to_optional_int(value):
    if value in (None, ""):
        return None
    try:
        return int(value)
    except (TypeError, ValueError):
        return None

@manage_inventory_bp.route('/manage_inventory/pcs-paged')
def pcs_paged():
    page = _normalize_page(request.args.get("page", 1, type=int))
    per_page = _normalize_per_page(request.args.get("per_page", DEFAULT_PER_PAGE, type=int))
    pc_filters = _get_pc_filters(request.args)

    pcs, total_items, total_pages, page = get_pc_list_paginated(page, per_page, pc_filters)
    request_source = request.headers.get('X-Request-Source', 'none')
    request_key = request.headers.get('X-Page-Request', 'none')
    print(f"📦 [pcs_paged] source={request_source} request_key={request_key} section={request.args.get('section')} page={page} per_page={per_page} total_items={total_items} total_pages={total_pages} filters={pc_filters}")

    return jsonify({
        "pcs": pcs,
        "page": page,
        "per_page": per_page,
        "total_items": total_items,
        "total_pages": total_pages
    })

def _get_pc_filters(args):
    return {
        "department_id": args.get("department_id"),
        "status": args.get("status"),
        "location": args.get("location"),
        "accountable": args.get("accountable"),
        "serial_no": args.get("serial_no"),
        "date_from": args.get("date_from"),
        "date_to": args.get("date_to"),
        "risk_level": args.get("risk_level"),
        "health_min": _to_optional_int(args.get("health_min")),
        "health_max": _to_optional_int(args.get("health_max")),
        "last_checked_from": args.get("last_checked_from"),
        "last_checked_to": args.get("last_checked_to"),
        "overdue": args.get("overdue"),
        "needs_checking": args.get("needs_checking"),
        "search": args.get("search"),
    }


def _compute_remaining_health_percent(asset_row, today=None):
    today = today or date.today()

    status_key = str(asset_row.get("status") or "").strip().lower()
    if status_key in {"damaged", "damage", "unusable"}:
        return 0.0

    interval_days = normalize_interval_days(asset_row.get("maintenance_interval_days"), default_days=30)
    last_checked = parse_date(asset_row.get("last_checked"))
    date_acquired = parse_date(asset_row.get("date_acquired"))

    # Only use a real baseline date; do not implicitly reset by defaulting to "today".
    baseline_date = last_checked or date_acquired
    if baseline_date is None:
        current_health = asset_row.get("health_score")
        try:
            current_health = float(current_health)
            return round(max(0.0, min(100.0, current_health)), 2)
        except (TypeError, ValueError):
            return 100.0

    elapsed_days = max(0, (today - baseline_date).days)
    remaining_percent = max(0.0, 100.0 - ((elapsed_days / interval_days) * 100.0))
    return round(remaining_percent, 2)
def get_pc_list_paginated(page=1, per_page=10, filters=None):
    """
    Fetch paginated PCs from pcinfofull excluding surrendered.
    Returns:
        pcs, total_items, total_pages, current_page
    """
    page = _normalize_page(page)
    per_page = _normalize_per_page(per_page)
    filters = filters or {}
    conn = get_db_connection()

    where_clauses = ["LOWER(COALESCE(pc.status, '')) != 'surrendered'", "COALESCE(pc.is_archived, 0) = 0"]
    query_params = []

    department_id = filters.get("department_id")
    status = filters.get("status")
    location = filters.get("location")
    accountable = filters.get("accountable")
    serial_no = filters.get("serial_no")
    date_from = filters.get("date_from")
    date_to = filters.get("date_to")
    risk_level = filters.get("risk_level")
    health_min = filters.get("health_min")
    health_max = filters.get("health_max")
    last_checked_from = filters.get("last_checked_from")
    last_checked_to = filters.get("last_checked_to")
    overdue_only = str(filters.get("overdue") or "") == "1"
    needs_checking = str(filters.get("needs_checking") or "") == "1"
    search = filters.get("search")

    if department_id:
        where_clauses.append("pc.department_id = %s")
        query_params.append(department_id)

    if status:
        where_clauses.append("pc.status = %s")
        query_params.append(status)

    if location:
        where_clauses.append("pc.location LIKE %s")
        query_params.append(f"%{location}%")

    if accountable:
        where_clauses.append("pc.accountable LIKE %s")
        query_params.append(f"%{accountable}%")

    if serial_no:
        where_clauses.append("(pc.serial_no LIKE %s OR pc.municipal_serial_no LIKE %s)")
        query_params.extend([f"%{serial_no}%", f"%{serial_no}%"])

    if date_from and date_to:
        where_clauses.append("pc.date_acquired BETWEEN %s AND %s")
        query_params.extend([date_from, date_to])
    elif date_from:
        where_clauses.append("pc.date_acquired >= %s")
        query_params.append(date_from)
    elif date_to:
        where_clauses.append("pc.date_acquired <= %s")
        query_params.append(date_to)

    if risk_level:
        where_clauses.append("(CASE WHEN LOWER(TRIM(pc.status)) IN ('damaged', 'damage', 'unusable') THEN 'High' ELSE pc.risk_level END) = %s")
        query_params.append(risk_level)

    if health_min is not None:
        where_clauses.append("pc.health_score >= %s")
        query_params.append(health_min)

    if health_max is not None:
        where_clauses.append("pc.health_score <= %s")
        query_params.append(health_max)

    if last_checked_from and last_checked_to:
        where_clauses.append("pc.last_checked BETWEEN %s AND %s")
        query_params.extend([last_checked_from, last_checked_to])
    elif last_checked_from:
        where_clauses.append("pc.last_checked >= %s")
        query_params.append(last_checked_from)
    elif last_checked_to:
        where_clauses.append("pc.last_checked <= %s")
        query_params.append(last_checked_to)

    if overdue_only:
        where_clauses.append("""(
            pc.last_checked IS NULL
            OR DATE_ADD(
                pc.last_checked,
                INTERVAL GREATEST(
                    1,
                    CASE
                        WHEN IFNULL(pc.maintenance_interval_days, 30) < 365
                            THEN IFNULL(pc.maintenance_interval_days, 30) * 365
                        ELSE IFNULL(pc.maintenance_interval_days, 30)
                    END
                ) DAY
            ) < CURDATE()
        )""")

    if needs_checking:
        where_clauses.append("pc.status = 'Needs Checking'")

    if search:
        where_clauses.append("(pc.pcname LIKE %s OR pc.motherboard LIKE %s OR pc.ram LIKE %s OR pc.storage LIKE %s OR pc.gpu LIKE %s)")
        query_params.extend([f"%{search}%"] * 5)

    where_sql = " WHERE " + " AND ".join(where_clauses)

    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:

            # Total count
            cur.execute(
                f"""
                SELECT COUNT(*) AS total
                FROM pcinfofull pc
                {where_sql}
                """,
                query_params,
            )
            total_items = cur.fetchone()["total"]

            total_pages = (total_items + per_page - 1) // per_page
            page = _clamp_page(page, total_pages)
            offset = (page - 1) * per_page

            # Paginated PC data
            cur.execute(f"""
                SELECT
                    pc.pcid,
                    pc.pcname,
                    pc.department_id,
                    dep.department_name,
                    pc.location,
                    pc.acquisition_cost,
                    pc.date_acquired,
                    pc.accountable,
                    pc.serial_no,
                    pc.municipal_serial_no,
                    pc.note,
                    pc.maintenance_interval_days,
                    pc.status,
                    pc.last_checked,
                    pc.health_score,
                    CASE WHEN LOWER(TRIM(pc.status)) IN ('damaged', 'damage', 'unusable') THEN 'High' ELSE pc.risk_level END AS risk_level,

                    -- ⭐ maintenance calculation
                    DATEDIFF(CURDATE(), pc.last_checked) AS days_since_check

                FROM pcinfofull pc
                LEFT JOIN departments dep
                    ON pc.department_id = dep.department_id
                {where_sql}
                ORDER BY pc.pcid DESC
                LIMIT %s OFFSET %s
            """, query_params + [per_page, offset])

            pcs = cur.fetchall()

            # Keep risk consistent with status even if legacy rows still carry stale risk values.
            for pc in pcs:
                status_key = str(pc.get("status") or "").strip().lower()
                if status_key in {"damaged", "damage", "unusable"}:
                    pc["risk_level"] = "High"
                elif not pc.get("risk_level"):
                    pc["risk_level"] = "--"

            _apply_precise_health_scores(pcs)
            

        return pcs, total_items, total_pages, page
    
    

    except Exception as e:
        print(f"❌ Error fetching paginated PCs: {e}")
        return [], 0, 0, 1

    finally:
        conn.close()

def get_pc_list():
    """Fetch all PCs with department and part details from pcinfofull."""
    conn = get_db_connection()
    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            cur.execute("""
                SELECT 
                    p.pcid,
                    p.pcname,
                    p.department_id,
                    d.department_name,
                    p.location,
                    p.quantity,
                    p.acquisition_cost,
                    p.date_acquired,
                    p.accountable,
                    p.serial_no,
                    p.municipal_serial_no,
                    p.status,
                    p.note,
                    p.maintenance_interval_days,
                    p.motherboard,
                    p.ram,
                    p.storage,
                    p.gpu,
                    p.psu,
                    p.casing,
                    p.other_parts,
                    p.risk_level,
                    p.health_score
                   
                
                FROM pcinfofull p
                LEFT JOIN departments d ON p.department_id = d.department_id
                ORDER BY p.pcid
            """)
            return cur.fetchall()
    except Exception as e:
        print(f"❌ Error fetching PC list: {e}")
        return []
    finally:
        conn.close()

 
def _apply_precise_health_scores(rows):
    if not rows:
        return

    today = date.today()
    for row in rows:
        row["health_score"] = _compute_remaining_health_percent(row, today=today)



@manage_inventory_bp.route('/manage_inventory/items-paged')
def items_paged():
    page = _normalize_page(request.args.get("page", 1, type=int))
    per_page = _normalize_per_page(request.args.get("per_page", DEFAULT_PER_PAGE, type=int))

    department_id = request.args.get('department_id')
    status = request.args.get('status')
    accountable = request.args.get('accountable')
    serial_no = request.args.get('serial_no')
    item_name = request.args.get('item_name')
    brand_model = request.args.get('brand_model')
    device_type = request.args.get('device_type')
    date_from = request.args.get('date_from')
    date_to = request.args.get('date_to')

    request_source = request.headers.get('X-Request-Source', 'none')
    request_key = request.headers.get('X-Page-Request', 'none')

    search = request.args.get('search')

    # If any filter is present, or a free-text search term was provided,
    # use the filtered paginated loader which supports search across key
    # device columns. Otherwise fall back to the unfiltered paged loader.
    if any([department_id, status, accountable, serial_no, item_name, brand_model, device_type, date_from, date_to]) or search:
        items, total_items, total_pages, page = get_filtered_item_list_paginated(
            page, per_page, department_id, status, accountable, serial_no, 
            item_name, brand_model, device_type, date_from, date_to, search
        )
    else:
        items, total_items, total_pages, page = get_item_list_paginated(page, per_page)

    print(
        f"📦 [items_paged] source={request_source} request_key={request_key} section={request.args.get('section')} "
        f"page={page} per_page={per_page} total_items={total_items} total_pages={total_pages} "
        f"filters={{'department_id': {department_id}, 'status': {status}, 'accountable': {accountable}, 'serial_no': {serial_no}, 'item_name': {item_name}, 'brand_model': {brand_model}, 'device_type': {device_type}, 'date_from': {date_from}, 'date_to': {date_to}}}"
    )

    return jsonify({
        "items": items,
        "page": page,
        "per_page": per_page,
        "total_items": total_items,
        "total_pages": total_pages
    })
 


@manage_inventory_bp.route('/manage_inventory/surrendered-pcs-paged')
def surrendered_pcs_paged():
    page = _normalize_page(request.args.get("page", 1, type=int))
    per_page = _normalize_per_page(request.args.get("per_page", DEFAULT_PER_PAGE, type=int))

    pcs, total_items, total_pages, page = get_surrendered_pc_list_paginated(page, per_page)

    return jsonify({
        "pcs": pcs,
        "page": page,
        "per_page": per_page,
        "total_items": total_items,
        "total_pages": total_pages
    })


@manage_inventory_bp.route('/manage_inventory/surrendered-items-paged')
def surrendered_items_paged():
    page = _normalize_page(request.args.get("page", 1, type=int))
    per_page = _normalize_per_page(request.args.get("per_page", DEFAULT_PER_PAGE, type=int))

    items, total_items, total_pages, page = get_surrendered_device_list_paginated(page, per_page)

    return jsonify({
        "items": items,
        "page": page,
        "per_page": per_page,
        "total_items": total_items,
        "total_pages": total_pages
    })


@manage_inventory_bp.route('/manage_inventory/consumables-paged')
def consumables_paged():
    page = _normalize_page(request.args.get("page", 1, type=int))
    per_page = _normalize_per_page(request.args.get("per_page", DEFAULT_PER_PAGE, type=int))

    department_id = request.args.get('department_id')
    status = request.args.get('status')
    accountable = request.args.get('accountable')
    item_name = request.args.get('item_name')
    brand_model = request.args.get('brand_model')
    date_from = request.args.get('date_from')
    date_to = request.args.get('date_to')

    search = request.args.get('search')

    consumables, total_items, total_pages, page = get_consumables_list_paginated(
        page=page,
        per_page=per_page,
        department_id=department_id,
        status=status,
        accountable=accountable,
        item_name=item_name,
        brand_model=brand_model,
        date_from=date_from,
        date_to=date_to,
        search=search
    )

    return jsonify({
        "consumables": consumables,
        "page": page,
        "per_page": per_page,
        "total_items": total_items,
        "total_pages": total_pages
    })


@manage_inventory_bp.route('/manage_inventory/get-departments')
def get_departments():
    conn = get_db_connection()
    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            cur.execute("""
                SELECT department_id, department_name 
                FROM departments 
                ORDER BY department_name
            """)
            departments = cur.fetchall()
        return jsonify(departments)
    except Exception as e:
        print(f"❌ Error fetching departments: {e}")
        return jsonify([]), 500
    finally:
        conn.close()


@manage_inventory_bp.route('/part-suggestions')
def part_suggestions():
    """Return a short list of device/items that match a requested PC part or free-text query.

    Query params:
      - part: name of the PC part (e.g. 'motherboard', 'ram')
      - q: free-text query to filter results
    """
    part = (request.args.get('part') or '').strip().lower()
    q = (request.args.get('q') or '').strip().lower()

    conn = get_db_connection()
    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            params = []
            where_clauses = ["COALESCE(df.is_archived, 0) = 0"]
            search_clauses = []

            if part:
                search_clauses.append("(LOWER(df.item_name) LIKE %s OR LOWER(df.device_type) LIKE %s OR LOWER(df.brand_model) LIKE %s)")
                params.extend([f"%{part}%"] * 3)

            if q:
                # if query is numeric, allow exact accession_id match
                if q.isdigit():
                    search_clauses.append("df.accession_id = %s")
                    params.append(int(q))

                search_clauses.append("(LOWER(df.item_name) LIKE %s OR LOWER(df.device_type) LIKE %s OR LOWER(df.brand_model) LIKE %s OR LOWER(df.serial_no) LIKE %s)")
                params.extend([f"%{q}%"] * 4)

            if search_clauses:
                where_clauses.append("(" + " OR ".join(search_clauses) + ")")

            where_sql = " AND ".join(where_clauses)

            sql = f"""
                SELECT df.accession_id, df.item_name, df.brand_model, df.serial_no
                FROM devices_full df
                WHERE {where_sql}
                ORDER BY df.accession_id DESC
                LIMIT 30
            """

            cur.execute(sql, params)
            rows = cur.fetchall()

            results = []
            for r in rows:
                name = (r.get('item_name') or '').strip()
                brand = (r.get('brand_model') or '').strip()
                label = name or str(r.get('accession_id'))
                if brand:
                    label = f"{label} — {brand}"
                results.append({
                    'accession_id': r.get('accession_id'),
                    'label': label
                })

        return jsonify(success=True, results=results)

    except Exception as e:
        print(f"❌ Error fetching part suggestions: {e}")
        return jsonify(success=False, results=[]), 500
    finally:
        conn.close()

def get_consumables_list_paginated(page=1, per_page=10, department_id=None, status=None,
                                  accountable=None, item_name=None, brand_model=None,
                                  date_from=None, date_to=None, search=None):
    page = _normalize_page(page)
    per_page = _normalize_per_page(per_page)
    conn = get_db_connection()
    try:
        # Detect whether the `is_archived` column exists in the consumables
        # table. Some installations don't have that column, and referencing
        # it directly causes a SQL error which returns an empty result set.
        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            cur.execute("""
                SELECT COUNT(*) AS cnt
                FROM information_schema.COLUMNS
                WHERE TABLE_SCHEMA = DATABASE()
                  AND TABLE_NAME = 'consumables'
                  AND COLUMN_NAME = 'is_archived'
            """)
            row = cur.fetchone()
            has_is_archived = bool(row and int(row.get('cnt', 0)) > 0)

        # Build base WHERE clause. Only include is_archived filter when
        # the column exists in the schema.
        where_sql = "WHERE 1=1"
        if has_is_archived:
            where_sql += " AND COALESCE(c.is_archived, 0) = 0"
        params = []

        if department_id:
            where_sql += " AND c.department_id = %s"
            params.append(department_id)

        if status:
            where_sql += " AND c.status = %s"
            params.append(status)

        if accountable:
            where_sql += " AND c.added_by LIKE %s"
            params.append(f"%{accountable}%")

        if item_name:
            where_sql += " AND c.item_name LIKE %s"
            params.append(f"%{item_name}%")

        if brand_model:
            where_sql += " AND c.brand LIKE %s"
            params.append(f"%{brand_model}%")

        if date_from and date_to:
            where_sql += " AND c.date_added BETWEEN %s AND %s"
            params.extend([date_from, date_to])

        # Broad free-text search across common consumable columns
        if search:
            where_sql += " AND (c.accession_id LIKE %s OR c.item_name LIKE %s OR c.brand LIKE %s OR c.location LIKE %s OR dep.department_name LIKE %s OR c.description LIKE %s)"
            params.extend([f"%{search}%"] * 6)

        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            cur.execute(
                """
                SELECT COUNT(*) AS total
                FROM consumables c
                LEFT JOIN devices_full df ON df.accession_id = c.accession_id
                """ + where_sql,
                params
            )
            total_items = cur.fetchone()["total"]

            total_pages = (total_items + per_page - 1) // per_page
            page = _clamp_page(page, total_pages)
            offset = (page - 1) * per_page

            cur.execute(
                """
                SELECT
                    c.accession_id,
                    c.item_name,
                    c.category,
                    c.brand,
                    c.quantity,
                    c.unit,
                    c.department_id,
                    dep.department_name,
                    c.location,
                    c.status,
                    c.description,
                    c.date_added,
                    c.last_updated
                FROM consumables c
                LEFT JOIN devices_full df ON df.accession_id = c.accession_id
                LEFT JOIN departments dep ON c.department_id = dep.department_id
                """ + where_sql + " ORDER BY c.accession_id DESC LIMIT %s OFFSET %s",
                params + [per_page, offset]
            )
            consumables = cur.fetchall()

        return consumables, total_items, total_pages, page

    except Exception as e:
        print(f"❌ Error fetching paginated consumables: {e}")
        return [], 0, 0, 1

    finally:
        conn.close()

@manage_inventory_bp.route('/inventory/pc/bulk-check', methods=['POST'])
def bulk_mark_pc_checked():
    data = request.get_json()
    pcids = data.get("pcids", [])

    if not pcids:
        return jsonify(success=False, error="No PCs selected"), 400

    conn = get_db_connection()

    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:

            for pcid in pcids:
                # Fetch old state
                cur.execute("""
                    SELECT status, risk_level
                    FROM pcinfofull
                    WHERE pcid = %s
                """, (pcid,))
                old = cur.fetchone()

                if not old:
                    continue

                # Update PC
                cur.execute("""
                    UPDATE pcinfofull
                    SET
                        last_checked = CURDATE(),
                        health_score = 100,
                        risk_level = 'Low',
                        status = 'Available'
                    WHERE pcid = %s
                """, (pcid,))

                # Maintenance log
                cur.execute("""
                    INSERT INTO maintenance_logs (
                        asset_type, asset_id,
                        previous_status, new_status,
                        previous_risk_level, new_risk_level,
                        action
                    ) VALUES (
                        'PC', %s,
                        %s, 'Available',
                        %s, 'Low',
                        'Bulk inspection completed'
                    )
                """, (
                    pcid,
                    old['status'],
                    old['risk_level']
                ))

                # Maintenance history
                cur.execute("""
                    INSERT INTO maintenance_history (
                        pcid,
                        asset_type,
                        asset_id,
                        action,
                        old_status,
                        new_status,
                        risk_level,
                        health_score,
                        performed_by,
                        remarks
                    ) VALUES (
                        %s, 'PC', %s,
                        'Bulk inspection completed',
                        %s, 'Available',
                        'Low', 100,
                        %s, %s
                    )
                """, (
                    pcid,
                    pcid,
                    old['status'],
                    'System',
                    'Bulk marked as checked'
                ))

        conn.commit()
        return jsonify(success=True)

    except Exception as e:
        conn.rollback()
        return jsonify(success=False, error=str(e)), 500

    finally:
        conn.close()


@manage_inventory_bp.route('/inventory/device/bulk-check', methods=['POST'])
def bulk_mark_device_checked():
    data = request.get_json()
    device_ids = data.get("device_ids", [])

    if not device_ids:
        return jsonify(success=False, error="No devices selected"), 400

    conn = get_db_connection()

    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:

            placeholders = ','.join(['%s'] * len(device_ids))

            # Get previous status/risk
            cur.execute(f"""
                SELECT accession_id, status, risk_level
                FROM devices_full
                WHERE accession_id IN ({placeholders})
            """, tuple(device_ids))

            devices = cur.fetchall()

            # Update devices
            cur.execute(f"""
                UPDATE devices_full
                SET
                    last_checked = CURDATE(),
                    health_score = 100,
                    risk_level = 'Low',
                    status = 'Available'
                WHERE accession_id IN ({placeholders})
            """, tuple(device_ids))

            # Insert logs
            for dev in devices:

                cur.execute("""
                    INSERT INTO maintenance_logs (
                        asset_type,
                        asset_id,
                        previous_status,
                        new_status,
                        previous_risk_level,
                        new_risk_level,
                        action
                    ) VALUES (
                        'Device',
                        %s,
                        %s,
                        'Available',
                        %s,
                        'Low',
                        'Bulk inspection completed'
                    )
                """, (
                    dev['accession_id'],
                    dev['status'],
                    dev['risk_level']
                ))

                cur.execute("""
                    INSERT INTO maintenance_history (
                        asset_type,
                        asset_id,
                        action,
                        old_status,
                        new_status,
                        risk_level,
                        health_score,
                        performed_by,
                        remarks
                    ) VALUES (
                        'Device',
                        %s,
                        'Bulk inspection completed',
                        %s,
                        'Available',
                        'Low',
                        100,
                        %s,
                        %s
                    )
                """, (
                    dev['accession_id'],
                    dev['status'],
                    'System',
                    'Bulk marked as checked'
                ))

        conn.commit()
        return jsonify(success=True)

    except Exception as e:
        conn.rollback()
        return jsonify(success=False, error=str(e)), 500

    finally:
        conn.close()

@manage_inventory_bp.route('/inventory/device/bulk-update', methods=['POST'])
def bulk_update_devices():
    data = request.get_json()
    device_ids = data.get("device_ids", [])
    new_status = data.get("new_status")

    if not device_ids or not new_status:
        return jsonify(success=False, error="Invalid input"), 400

    conn = get_db_connection()

    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            for accession_id in device_ids:

                # Fetch old state
                cur.execute("""
                    SELECT status, risk_level, health_score
                    FROM devices_full
                    WHERE accession_id = %s
                """, (accession_id,))
                old = cur.fetchone()

                if not old:
                    continue

                # ---- Risk & health rules ----
                if new_status == "Available":
                    risk = "Low"
                    health = 100
                elif new_status == "Needs Checking":
                    risk = "Medium"
                    health = 50
                elif new_status in ("Damaged", "For Repair"):
                    risk = "High"
                    health = 30
                elif new_status in ("Unusable", "Condemned"):
                    risk = "High"
                    health = 0
                else:
                    risk = old["risk_level"]
                    health = old["health_score"]

                # ---- Update device ----
                cur.execute("""
                    UPDATE devices_full
                    SET
                        status = %s,
                        risk_level = %s,
                        health_score = %s,
                        updated_at = NOW()
                    WHERE accession_id = %s
                """, (new_status, risk, health, accession_id))

                # ---- maintenance_logs ----
                cur.execute("""
                    INSERT INTO maintenance_logs (
                        asset_type, asset_id,
                        previous_status, new_status,
                        previous_risk_level, new_risk_level,
                        action
                    ) VALUES (
                        'DEVICE', %s,
                        %s, %s,
                        %s, %s,
                        'Bulk status update'
                    )
                """, (
                    accession_id,
                    old["status"],
                    new_status,
                    old["risk_level"],
                    risk
                ))

                # ---- maintenance_history ----
                cur.execute("""
                    INSERT INTO maintenance_history (
                        asset_type,
                        asset_id,
                        action,
                        old_status,
                        new_status,
                        risk_level,
                        health_score,
                        performed_by,
                        remarks
                    ) VALUES (
                        'Device', %s,
                        'Bulk status update',
                        %s, %s,
                        %s, %s,
                        %s,
                        %s
                    )
                """, (
                    accession_id,
                    old["status"],
                    new_status,
                    risk,
                    health,
                    'System',
                    f'Bulk marked as {new_status}'
                ))

        conn.commit()
        return jsonify(success=True)
    except Exception as e:
        conn.rollback()
        return jsonify(success=False, error=str(e)), 500
    finally:
        conn.close()


@manage_inventory_bp.route('/inventory/pc/bulk-surrender', methods=['POST'])
def bulk_surrender_pcs():
    """Mark selected PCs as surrendered."""
    data = request.get_json(silent=True) or {}
    pcids = data.get('pcids', [])

    if not pcids:
        return jsonify(success=False, error="No PCs selected"), 400

    conn = get_db_connection()
    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            placeholders = ','.join(['%s'] * len(pcids))

            # Capture previous state first so history reflects real before/after values.
            cur.execute(
                f"""
                SELECT pcid, status, risk_level
                FROM pcinfofull
                WHERE pcid IN ({placeholders})
                """,
                tuple(pcids)
            )
            old_rows = cur.fetchall()
            old_map = {str(row['pcid']): row for row in old_rows}

            cur.execute(
                # If the schema provides an `is_archived` column, mark surrendered PCs as archived too
                """
                SELECT COUNT(*) AS cnt
                FROM information_schema.COLUMNS
                WHERE TABLE_SCHEMA = DATABASE()
                  AND TABLE_NAME = 'pcinfofull'
                  AND COLUMN_NAME = 'is_archived'
                """
            )
            row = cur.fetchone()
            has_is_arch = bool(row and int(row.get('cnt', 0)) > 0)

            if has_is_arch:
                cur.execute(
                    f"UPDATE pcinfofull SET status = 'Surrendered', is_archived = 1, deleted_at = NOW() WHERE pcid IN ({placeholders})",
                    tuple(pcids)
                )
            else:
                cur.execute(
                    f"UPDATE pcinfofull SET status = 'Surrendered' WHERE pcid IN ({placeholders})",
                    tuple(pcids)
                )

            # Insert maintenance_logs and history entries for each pc
            for pcid in pcids:
                old = old_map.get(str(pcid))
                prev_status = old['status'] if old else None
                prev_risk = old['risk_level'] if old else None

                cur.execute("""
                    INSERT INTO maintenance_logs (
                        asset_type, asset_id,
                        previous_status, new_status,
                        previous_risk_level, new_risk_level,
                        action
                    ) VALUES (
                        'PC', %s,
                        %s, 'Surrendered',
                        %s, %s,
                        'Bulk surrender'
                    )
                """, (
                    pcid,
                    prev_status,
                    prev_risk,
                    prev_risk
                ))

                cur.execute("""
                    INSERT INTO maintenance_history (
                        pcid,
                        asset_type,
                        asset_id,
                        action,
                        old_status,
                        new_status,
                        risk_level,
                        health_score,
                        performed_by,
                        remarks
                    ) VALUES (
                        %s, 'PC', %s,
                        'Bulk surrender',
                        %s, 'Surrendered',
                        %s, NULL,
                        %s, %s
                    )
                """, (
                    pcid,
                    pcid,
                    prev_status,
                    prev_risk,
                    'System',
                    'Bulk surrendered'
                ))

        conn.commit()
        return jsonify(success=True)
    except Exception as e:
        conn.rollback()
        print(f"❌ Error bulk surrendering PCs: {e}")
        return jsonify(success=False, error=str(e)), 500
    finally:
        conn.close()


@manage_inventory_bp.route('/inventory/device/bulk-surrender', methods=['POST'])
def bulk_surrender_devices():
    """Mark selected devices as surrendered."""
    data = request.get_json(silent=True) or {}
    device_ids = data.get('device_ids', [])

    if not device_ids:
        return jsonify(success=False, error="No devices selected"), 400

    conn = get_db_connection()
    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            placeholders = ','.join(['%s'] * len(device_ids))

            # Capture previous state before update for logging.
            cur.execute(
                f"""
                SELECT accession_id, status, risk_level
                FROM devices_full
                WHERE accession_id IN ({placeholders})
                """,
                tuple(device_ids)
            )
            old_rows = cur.fetchall()
            old_map = {str(row['accession_id']): row for row in old_rows}

            # If devices_full supports archiving, mark surrendered devices as archived too
            cur.execute(
                """
                SELECT COUNT(*) AS cnt
                FROM information_schema.COLUMNS
                WHERE TABLE_SCHEMA = DATABASE()
                  AND TABLE_NAME = 'devices_full'
                  AND COLUMN_NAME = 'is_archived'
                """
            )
            row = cur.fetchone()
            has_is_arch = bool(row and int(row.get('cnt', 0)) > 0)

            if has_is_arch:
                cur.execute(
                    f"UPDATE devices_full SET status = 'Surrendered', is_archived = 1, deleted_at = NOW() WHERE accession_id IN ({placeholders})",
                    tuple(device_ids)
                )
            else:
                cur.execute(
                    f"""
                    UPDATE devices_full
                    SET status = 'Surrendered'
                    WHERE accession_id IN ({placeholders})
                    """,
                    tuple(device_ids)
                )

            for accession_id in device_ids:
                old = old_map.get(str(accession_id))
                prev_status = old['status'] if old else None
                prev_risk = old['risk_level'] if old else None

                cur.execute(
                    """
                    INSERT INTO maintenance_logs (
                        asset_type,
                        asset_id,
                        previous_status,
                        new_status,
                        previous_risk_level,
                        new_risk_level,
                        action
                    ) VALUES (
                        'DEVICE',
                        %s,
                        %s,
                        'Surrendered',
                        %s,
                        %s,
                        'Bulk surrender'
                    )
                    """,
                    (
                        accession_id,
                        prev_status,
                        prev_risk,
                        prev_risk,
                    )
                )

                cur.execute(
                    """
                    INSERT INTO maintenance_history (
                        pcid,
                        asset_type,
                        asset_id,
                        action,
                        old_status,
                        new_status,
                        risk_level,
                        health_score,
                        performed_by,
                        remarks
                    ) VALUES (
                        NULL,
                        'Device',
                        %s,
                        'Bulk surrender',
                        %s,
                        'Surrendered',
                        %s,
                        NULL,
                        %s,
                        %s
                    )
                    """,
                    (
                        accession_id,
                        prev_status,
                        prev_risk,
                        'System',
                        'Bulk surrendered',
                    )
                )

        conn.commit()
        return jsonify(success=True)

    except Exception as e:
        conn.rollback()
        print(f"❌ Error bulk surrendering devices: {e}")
        return jsonify(success=False, error=str(e)), 500

    finally:
        conn.close()
 

 
def get_departments_list():
    """Get all departments for filter dropdowns."""
    conn = get_db_connection()
    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            cur.execute("SELECT department_id, department_name FROM departments ORDER BY department_name")
            return cur.fetchall()
        
        
    except Exception as e:
        print(f"Error fetching departments: {e}")
        return []
    finally:
        conn.close()


 

def get_item_list():
    """Fetch all devices from devices_full (for Manage Items section)."""
    conn = get_db_connection()
    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            cur.execute("""
                SELECT 
                    df.accession_id AS accession_id,
                    df.item_name,
                    df.brand_model,
                    df.serial_no,
                    df.municipal_serial_no,
                    df.quantity,
                    df.device_type,
                    df.acquisition_cost,
                    df.date_acquired,
                    df.accountable,
                    df.department_id,
                    dep.department_name,
                    df.status,
                    df.updated_at
                    df.risk_level,
                    df.health_score,
                    df.last_checked,
                    df.maintenance_interval_days
                    df.note,
                    df.location,
                    df.supplier
                FROM devices_full df
                LEFT JOIN departments dep ON df.department_id = dep.department_id
                WHERE COALESCE(df.is_archived, 0) = 0 AND LOWER(COALESCE(df.status, '')) != 'surrendered'
                ORDER BY df.accession_id DESC
            """)
            return cur.fetchall()
    except Exception as e:
        print(f"❌ Error fetching item list: {e}")
        return []
    finally:
        conn.close()
 

@manage_inventory_bp.route('/manage_inventory/get-item-by-id/<int:item_id>')
def get_item_by_id(item_id):
    """Fetch a single device record with full details."""
    conn = get_db_connection()
    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            cur.execute("""
                SELECT 
                    df.accession_id AS accession_id,
                    df.item_name,
                    df.brand_model,
                    df.serial_no,
                    df.municipal_serial_no,
                    df.quantity,
                    df.device_type,
                    df.acquisition_cost,
                    df.date_acquired,
                    df.accountable,
                    df.department_id,
                    dep.department_name,
                    df.status,
                    df.updated_at
                FROM devices_full df
                LEFT JOIN departments dep 
                    ON df.department_id = dep.department_id
                WHERE df.accession_id = %s
            """, (item_id,))
            item = cur.fetchone()

        if not item:
            return jsonify({'error': 'Item not found'}), 404

        return jsonify(item)
    except Exception as e:
        print(f"❌ Error fetching item by ID: {e}")
        return jsonify({'error': 'Database error'}), 500
    finally:
        conn.close()

 
 

@manage_inventory_bp.route('/manage_inventory/get-pc-by-id/<int:pcid>')
def get_pc_by_id(pcid):

    
    conn = get_db_connection()
    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            cur.execute("""
                SELECT 
                    p.pcid,
                    p.pcname,
                    p.department_id,
                    d.department_name,
                    p.location,
                    p.quantity,
                    p.acquisition_cost,
                    p.date_acquired,
                    p.accountable,
                    p.serial_no,
                    p.municipal_serial_no,
                    p.status,
                    p.note,
                    p.maintenance_interval_days,
                    p.motherboard,
                    p.ram,
                    p.storage,
                    p.gpu,
                    p.psu,
                    p.casing,
                    p.other_parts
                FROM pcinfofull p
                LEFT JOIN departments d ON p.department_id = d.department_id
                WHERE p.pcid = %s
            """, (pcid,))
            pc = cur.fetchone()

            if not pc:
                return {"error": "PC not found"}, 404

            return pc
    except Exception as e:
        print(f"❌ Error fetching PC by ID: {e}")
        return {"error": "Database error"}, 500
    finally:
        conn.close()

 


@manage_inventory_bp.route('/manage_inventory/pc-filter-modal')
def pc_filter_modal():
    return render_template('pcFilterModal.html')
def run_inventory_auto_check():
    print("🔄 Running inventory auto-check...")

    pc_result = _run_asset_risk_update("pcinfofull", "pcid", "PC")
    device_result = _run_asset_risk_update("devices_full", "accession_id", "Device")

    if not pc_result.get("success") or not device_result.get("success"):
        print("❌ Inventory auto-check failed:", pc_result.get("error") or device_result.get("error"))
        return

    print(
        "✅ Inventory auto-check complete. "
        f"PC updated: {pc_result.get('updated', 0)}, "
        f"Device updated: {device_result.get('updated', 0)}"
    )
def get_surrendered_pc_list_paginated(page=1, per_page=10):
    """
    Fetch paginated PCs from pcinfofull where status = 'Surrendered'.
    Returns:
        pcs, total_items, total_pages, current_page
    """
    page = _normalize_page(page)
    per_page = _normalize_per_page(per_page)
    conn = get_db_connection()

    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            # Total count for surrendered PCs
            cur.execute("SELECT COUNT(*) AS total FROM pcinfofull WHERE status = 'Surrendered'")
            total_items = cur.fetchone()["total"]

            total_pages = (total_items + per_page - 1) // per_page
            page = _clamp_page(page, total_pages)
            offset = (page - 1) * per_page

            # Paginated surrendered PC data
            cur.execute("""
                SELECT
                    pc.pcid,
                    pc.pcname,
                    pc.department_id,
                    dep.department_name,
                    pc.location,
                    pc.acquisition_cost,
                    pc.date_acquired,
                    pc.accountable,
                    pc.serial_no,
                    pc.municipal_serial_no,
                    pc.note,
                    pc.status,
                    pc.last_checked,
                    pc.health_score,
                    pc.risk_level
                FROM pcinfofull pc
                LEFT JOIN departments dep
                    ON pc.department_id = dep.department_id
                WHERE pc.status = 'Surrendered'
                ORDER BY pc.pcid DESC
                LIMIT %s OFFSET %s
            """, (per_page, offset))

            pcs = cur.fetchall()

        return pcs, total_items, total_pages, page

    except Exception as e:
        print(f"❌ Error fetching surrendered paginated PCs: {e}")
        return [], 0, 0, 1

    finally:
        conn.close()


def get_surrendered_device_list_paginated(page=1, per_page=10):
    """Fetch paginated surrendered devices/items for the surrendered items section."""
    page = _normalize_page(page)
    per_page = _normalize_per_page(per_page)
    conn = get_db_connection()

    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            cur.execute("""
                SELECT COUNT(*) AS total
                FROM devices_full
                WHERE COALESCE(TRIM(LOWER(status)), '') = 'surrendered'
            """)
            total_items = cur.fetchone()["total"]

            total_pages = (total_items + per_page - 1) // per_page
            page = _clamp_page(page, total_pages)
            offset = (page - 1) * per_page

            cur.execute("""
                SELECT
                    df.accession_id,
                    df.item_name,
                    df.brand_model,
                    df.device_type,
                    df.department_id,
                    dep.department_name,
                    df.accountable,
                    df.serial_no,
                    df.municipal_serial_no,
                    df.quantity,
                    df.acquisition_cost,
                    df.date_acquired,
                    df.status
                FROM devices_full df
                LEFT JOIN departments dep
                    ON df.department_id = dep.department_id
                WHERE COALESCE(TRIM(LOWER(df.status)), '') = 'surrendered'
                ORDER BY df.updated_at DESC, df.accession_id DESC
                LIMIT %s OFFSET %s
            """, (per_page, offset))
            items = cur.fetchall()

            return items, total_items, total_pages, page

    except Exception as e:
        print(f"❌ Error fetching surrendered devices: {e}")
        return [], 0, 0, 1

    finally:
        conn.close()
 
def get_item_list_paginated(page=1, per_page=10):
    """
    Fetch paginated devices from devices_full, excluding surrendered records.
    Returns:
        items, total_items, total_pages, current_page
    """
    page = _normalize_page(page)
    per_page = _normalize_per_page(per_page)
    conn = get_db_connection()

    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            # Get total count
            cur.execute("""
                SELECT COUNT(*) AS total
                FROM devices_full
                WHERE is_archived = 0
                  AND COALESCE(TRIM(LOWER(status)), '') NOT IN ('surrendered', 'archived')
            """)
            total_items = cur.fetchone()["total"]

            total_pages = (total_items + per_page - 1) // per_page
            page = _clamp_page(page, total_pages)
            offset = (page - 1) * per_page

            # Get paginated data
            cur.execute("""
                SELECT 
                    df.accession_id AS accession_id,
                    df.item_name,
                    df.brand_model,
                    df.serial_no,
                    df.municipal_serial_no,
                    df.quantity,
                    df.device_type,
                    df.acquisition_cost,
                    df.date_acquired,
                    df.accountable,
                    df.department_id,
                    dep.department_name,
                    df.status,
                    df.updated_at,
                    CASE WHEN LOWER(TRIM(df.status)) IN ('damaged', 'damage', 'unusable') THEN 'High' ELSE df.risk_level END AS risk_level,
                    df.health_score,
                    df.last_checked,
                    df.maintenance_interval_days
                FROM devices_full df
                LEFT JOIN departments dep ON df.department_id = dep.department_id
                WHERE df.is_archived = 0
                  AND COALESCE(TRIM(LOWER(df.status)), '') NOT IN ('surrendered', 'archived')
                ORDER BY df.updated_at DESC, df.accession_id DESC
                LIMIT %s OFFSET %s
            """, (per_page, offset))

            items = cur.fetchall()

            _apply_precise_health_scores(items)

        return items, total_items, total_pages, page

    except Exception as e:
        print(f"❌ Error fetching paginated items: {e}")
        return [], 0, 0, 1
    finally:
        conn.close()

 

def get_filtered_item_list_paginated(page=1, per_page=10, department_id=None, status=None, 
                                   accountable=None, serial_no=None, item_name=None, 
                                   brand_model=None, device_type=None, date_from=None, date_to=None, search=None):
    """
    Fetch paginated and filtered devices from devices_full.
    Returns:
        items, total_items, total_pages, current_page
    """
    page = _normalize_page(page)
    per_page = _normalize_per_page(per_page)
    conn = get_db_connection()

    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            # Build the base query with filters
            query = """
                SELECT 
                    df.accession_id AS accession_id,
                    df.item_name,
                    df.brand_model,
                    df.serial_no,
                    df.municipal_serial_no,
                    df.quantity,
                    df.device_type,
                    df.acquisition_cost,
                    df.date_acquired,
                    df.accountable,
                    df.department_id,
                    dep.department_name,
                    df.status,
                    df.updated_at,
                    CASE WHEN LOWER(TRIM(df.status)) IN ('damaged', 'damage', 'unusable') THEN 'High' ELSE df.risk_level END AS risk_level,
                    df.health_score,
                    df.last_checked,
                    df.maintenance_interval_days
                FROM devices_full df
                LEFT JOIN departments dep ON df.department_id = dep.department_id
                WHERE 1=1
                                    AND df.is_archived = 0
                                    AND COALESCE(TRIM(LOWER(df.status)), '') NOT IN ('surrendered', 'archived')
            """
            params = []

            # Apply filters dynamically
            if department_id:
                query += " AND df.department_id = %s"
                params.append(department_id)
            if status:
                query += " AND df.status = %s"
                params.append(status)
            if accountable:
                query += " AND df.accountable LIKE %s"
                params.append(f"%{accountable}%")
            if serial_no:
                query += " AND (df.serial_no LIKE %s OR df.municipal_serial_no LIKE %s)"
                params.extend([f"%{serial_no}%", f"%{serial_no}%"])
            if item_name:
                query += " AND df.item_name LIKE %s"
                params.append(f"%{item_name}%")
            if brand_model:
                query += " AND df.brand_model LIKE %s"
                params.append(f"%{brand_model}%")
            if device_type:
                query += " AND df.device_type LIKE %s"
                params.append(f"%{device_type}%")
            if date_from and date_to:
                query += " AND df.date_acquired BETWEEN %s AND %s"
                params.extend([date_from, date_to])

            # Broad free-text search across common item columns
            if search:
                query += " AND (df.accession_id LIKE %s OR df.item_name LIKE %s OR df.brand_model LIKE %s OR df.serial_no LIKE %s OR dep.department_name LIKE %s OR df.accountable LIKE %s)"
                params.extend([f"%{search}%"] * 6)

            # Get total count with same filters (subquery is safer than string replacements)
            count_query = f"SELECT COUNT(*) AS total FROM ({query}) AS filtered_items"

            cur.execute(count_query, params)
            total_items = cur.fetchone()["total"]

            total_pages = (total_items + per_page - 1) // per_page
            page = _clamp_page(page, total_pages)
            offset = (page - 1) * per_page

            # Get paginated data
            query += " ORDER BY df.updated_at DESC, df.accession_id DESC LIMIT %s OFFSET %s"
            params.extend([per_page, offset])

            cur.execute(query, params)
            items = cur.fetchall()

            _apply_precise_health_scores(items)

        return items, total_items, total_pages, page

    except Exception as e:
        print(f"❌ Error fetching filtered paginated items: {e}")
        return [], 0, 0, 1

    finally:
        conn.close()
 
@manage_inventory_bp.route('/manage_inventory/run-risk-update', methods=['POST'])
def run_risk_update():
    result = _run_asset_risk_update("pcinfofull", "pcid", "PC")
    return jsonify(result), 200 if result.get("success") else 500


@manage_inventory_bp.route('/manage_inventory/run-device-risk-update', methods=['POST'])
def run_device_risk_update():
    result = _run_asset_risk_update("devices_full", "accession_id", "Device")
    return jsonify(result), 200 if result.get("success") else 500


def _run_asset_risk_update(table_name, id_column, asset_type):
    conn = get_db_connection()
    locked_statuses = {"damaged", "damage", "surrendered", "unusable"}

    stats = {
        "success": False,
        "message": f"{asset_type} risk update failed.",
        "updated": 0,
        "low_count": 0,
        "medium_count": 0,
        "high_count": 0,
        "pc_count": 0,
        "device_count": 0,
    }

    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            cur.execute(f"""
                SELECT
                    {id_column} AS asset_id,
                    status,
                    risk_level,
                    date_acquired,
                    last_checked,
                    maintenance_interval_days
                FROM {table_name}
            """)
            assets = cur.fetchall()

            if asset_type == "PC":
                stats["pc_count"] = len(assets)
            else:
                stats["device_count"] = len(assets)

            for asset in assets:
                asset_id = asset.get("asset_id")
                old_status = asset.get("status") or ""
                old_risk = asset.get("risk_level") or ""
                normalized_status = old_status.strip().lower()

                health, risk = calculate_health_and_risk(asset)

                if risk == "Low":
                    stats["low_count"] += 1
                elif risk == "Medium":
                    stats["medium_count"] += 1
                else:
                    stats["high_count"] += 1

                if normalized_status in locked_statuses:
                    new_status = old_status
                else:
                    new_status = "Needs Checking" if risk == "High" else old_status

                cur.execute(
                    f"""
                    UPDATE {table_name}
                    SET
                        health_score = %s,
                        risk_level = %s,
                        status = %s
                    WHERE {id_column} = %s
                    """,
                    (health, risk, new_status, asset_id)
                )

                if old_status != new_status or old_risk != risk:
                    stats["updated"] += 1

                    if asset_type == "PC":
                        cur.execute(
                            """
                            INSERT INTO maintenance_history
                            (pcid, asset_type, asset_id, action, old_status, new_status,
                             risk_level, health_score, performed_by, remarks)
                            VALUES (%s, 'PC', %s, %s, %s, %s, %s, %s, %s, %s)
                            """,
                            (
                                asset_id,
                                asset_id,
                                "Auto Risk Update",
                                old_status,
                                new_status,
                                risk,
                                health,
                                "System",
                                "Updated via Manage Inventory risk recalculation",
                            )
                        )
                    else:
                        cur.execute(
                            """
                            INSERT INTO maintenance_history
                            (asset_type, asset_id, action, old_status, new_status,
                             risk_level, health_score, performed_by, remarks)
                            VALUES ('Device', %s, %s, %s, %s, %s, %s, %s, %s)
                            """,
                            (
                                asset_id,
                                "Auto Risk Update",
                                old_status,
                                new_status,
                                risk,
                                health,
                                "System",
                                "Updated via Manage Inventory risk recalculation",
                            )
                        )

        conn.commit()

        stats["success"] = True
        stats["message"] = f"{asset_type} risk levels recalculated."
        return stats

    except Exception as e:
        conn.rollback()
        print(f"{asset_type} risk update error:", e)
        stats["error"] = str(e)
        return stats

    finally:
        conn.close()


def apply_medium_risk_rules():
    conn = get_db_connection()
    try:
        with conn.cursor() as cur:
            cur.execute("""
                UPDATE pcinfofull
                SET status = 'Needs Checking'
                WHERE risk_level = 'Medium'
                  AND status != 'Needs Checking'
            """)

            cur.execute("""
                UPDATE devices_full
                SET status = 'Needs Checking'
                WHERE risk_level = 'Medium'
                  AND status != 'Needs Checking'
            """)

        conn.commit()
    except Exception as e:
        conn.rollback()
        print("❌ Medium risk rule error:", e)
    finally:
        conn.close()
def apply_maintenance_overdue_rules():
    conn = get_db_connection()
    try:
        with conn.cursor() as cur:

            # ✅ PCs
            cur.execute("""
                UPDATE pcinfofull
                SET 
                    status = 'Needs Checking',
                    risk_level = 'Medium',
                    health_score = 50
                WHERE 
                    maintenance_interval_days IS NOT NULL
                    AND (
                        last_checked IS NULL
                        OR DATEDIFF(CURDATE(), last_checked) > GREATEST(
                            1,
                            CASE
                                WHEN IFNULL(maintenance_interval_days, 30) < 365
                                    THEN IFNULL(maintenance_interval_days, 30) * 365
                                ELSE IFNULL(maintenance_interval_days, 30)
                            END
                        )
                    )
                    AND status NOT IN ('Damaged', 'Surrendered', 'Unusable')
            """)

            # ✅ Devices
            cur.execute("""
                UPDATE devices_full
                SET 
                    status = 'Needs Checking',
                    risk_level = 'Medium',
                    health_score = 50
                WHERE 
                    maintenance_interval_days IS NOT NULL
                    AND (
                        last_checked IS NULL
                        OR DATEDIFF(CURDATE(), last_checked) > GREATEST(
                            1,
                            CASE
                                WHEN IFNULL(maintenance_interval_days, 30) < 365
                                    THEN IFNULL(maintenance_interval_days, 30) * 365
                                ELSE IFNULL(maintenance_interval_days, 30)
                            END
                        )
                    )
                    AND status NOT IN ('Damaged', 'Unusable')
            """)

        conn.commit()

    except Exception as e:
        conn.rollback()
        print("❌ Maintenance overdue rule error:", e)

    finally:
        conn.close()
    conn = get_db_connection()
    try:
        with conn.cursor() as cur:

            # ✅ PCs
            cur.execute("""
                UPDATE pcinfofull
                SET 
                    status = 'Needs Checking',
                    risk_level = 'Medium',
                    health_score = 50
                WHERE 
                    (
    last_checked IS NULL
    OR DATEDIFF(CURDATE(), last_checked) > GREATEST(
        1,
        CASE
            WHEN IFNULL(maintenance_interval_days, 30) < 365
                THEN IFNULL(maintenance_interval_days, 30) * 365
            ELSE IFNULL(maintenance_interval_days, 30)
        END
    )
)
                    AND maintenance_interval_days IS NOT NULL
                    AND DATEDIFF(CURDATE(), last_checked) > GREATEST(
                        1,
                        CASE
                            WHEN IFNULL(maintenance_interval_days, 30) < 365
                                THEN IFNULL(maintenance_interval_days, 30) * 365
                            ELSE IFNULL(maintenance_interval_days, 30)
                        END
                    )
                    AND status NOT IN ('Damaged', 'Surrendered', 'Unusable')
            """)

            # ✅ Devices
            cur.execute("""
                UPDATE devices_full
                SET 
                    status = 'Needs Checking',
                    risk_level = 'Medium',
                    health_score = 50
                WHERE 
(
    last_checked IS NULL
    OR DATEDIFF(CURDATE(), last_checked) > GREATEST(
        1,
        CASE
            WHEN IFNULL(maintenance_interval_days, 30) < 365
                THEN IFNULL(maintenance_interval_days, 30) * 365
            ELSE IFNULL(maintenance_interval_days, 30)
        END
    )
)                    AND maintenance_interval_days IS NOT NULL
                    AND DATEDIFF(CURDATE(), last_checked) > GREATEST(
                        1,
                        CASE
                            WHEN IFNULL(maintenance_interval_days, 30) < 365
                                THEN IFNULL(maintenance_interval_days, 30) * 365
                            ELSE IFNULL(maintenance_interval_days, 30)
                        END
                    )
                    AND status NOT IN ('Damaged', 'Unusable')
            """)

        conn.commit()

    except Exception as e:
        conn.rollback()
        print("❌ Maintenance overdue rule error:", e)

    finally:
        conn.close()
@manage_inventory_bp.route('/inventory/pc/<int:pcid>/check', methods=['POST'])
def mark_pc_checked(pcid):
    conn = get_db_connection()
    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            cur.execute("""
                SELECT status, risk_level
                FROM pcinfofull
                WHERE pcid = %s
            """, (pcid,))
            old = cur.fetchone()

            cur.execute("""
                UPDATE pcinfofull
                SET
                    last_checked = CURDATE(),
                    health_score = 100,
                    risk_level = 'Low',
                    status = 'Available'
                WHERE pcid = %s
            """, (pcid,))

            cur.execute("""
                INSERT INTO maintenance_logs (
                    asset_type, asset_id,
                    previous_status, new_status,
                    previous_risk_level, new_risk_level,
                    action
                ) VALUES (
                    'PC', %s,
                    %s, 'Available',
                    %s, 'Low',
                    'Manual inspection completed'
                )
            """, (
                pcid,
                old['status'],
                old['risk_level']
            ))
            cur.execute("""
                INSERT INTO maintenance_history (
                    pcid, asset_type, asset_id,
                    action, old_status, new_status,
                    risk_level, health_score, performed_by, remarks
                ) VALUES (
                    %s, 'PC', %s,
                    'Manual inspection completed', %s, 'Available',
                    'Low', 100, %s, %s
                )
            """, (
                pcid,
                pcid,
                old['status'],
                'System',   # you can replace 'System' with current user if available
                'Marked as checked manually'
            ))

        conn.commit()
        return jsonify(success=True)

    except Exception as e:
        conn.rollback()
        return jsonify(success=False, error=str(e)), 500
    finally:
        conn.close()

 
@manage_inventory_bp.route('/maintenance-history')
def maintenance_history():
    asset_id = request.args.get('id', type=int)
    asset_type = (request.args.get('type') or '').strip().upper()

    if not asset_id or not asset_type:
        return render_template('maintenance_history.html', logs=[])

    conn = get_db_connection()
    with conn.cursor(pymysql.cursors.DictCursor) as cur:
        cur.execute("""
            SELECT
                ml.*,
                CASE
                    WHEN LOWER(TRIM(ml.previous_status)) IN ('damaged', 'damage', 'unusable') THEN 'High'
                    WHEN ml.previous_risk_level IS NULL OR TRIM(ml.previous_risk_level) = '' THEN '--'
                    ELSE ml.previous_risk_level
                END AS effective_previous_risk_level,
                CASE
                    WHEN LOWER(TRIM(ml.new_status)) IN ('damaged', 'damage', 'unusable') THEN 'High'
                    WHEN ml.new_risk_level IS NULL OR TRIM(ml.new_risk_level) = '' THEN '--'
                    ELSE ml.new_risk_level
                END AS effective_new_risk_level
            FROM maintenance_logs ml
            WHERE UPPER(TRIM(ml.asset_type)) = %s
              AND ml.asset_id = %s
            ORDER BY performed_at DESC
        """, (asset_type, asset_id))
        logs = cur.fetchall()

    conn.close()
    return render_template('maintenance_history.html', logs=logs)

@manage_inventory_bp.route('/inventory/<string:asset_type>/<int:asset_id>/check', methods=['POST'])
def mark_asset_checked(asset_type, asset_id):
    route_asset_type = (asset_type or '').upper()
    history_asset_type = 'PC' if route_asset_type == 'PC' else 'Device'
    conn = get_db_connection()

    if route_asset_type not in ['PC', 'DEVICE']:
        return jsonify(success=False, error="Invalid asset type"), 400

    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:

            # ---------- TARGET TABLE ----------
            if route_asset_type == 'PC':
                table = 'pcinfofull'
                id_field = 'pcid'
            else:
                table = 'devices_full'
                id_field = 'accession_id'

            # ---------- FETCH OLD STATE ----------
            cur.execute(f"""
                SELECT status, risk_level, health_score
                FROM {table}
                WHERE {id_field} = %s
            """, (asset_id,))
            old = cur.fetchone()

            if not old:
                return jsonify(success=False, error="Asset not found"), 404

            # ---------- UPDATE ASSET ----------
            cur.execute(f"""
                UPDATE {table}
                SET
                    last_checked = CURDATE(),
                    health_score = 100,
                    risk_level = 'Low',
                    status = 'Available'
                WHERE {id_field} = %s
            """, (asset_id,))

            # ---------- MAINTENANCE LOG ----------
            cur.execute("""
                INSERT INTO maintenance_logs (
                    asset_type,
                    asset_id,
                    previous_status,
                    new_status,
                    previous_risk_level,
                    new_risk_level,
                    action
                ) VALUES (
                    %s, %s,
                    %s, 'Available',
                    %s, 'Low',
                    'Manual inspection completed'
                )
            """, (
                route_asset_type,
                asset_id,
                old['status'],
                old['risk_level']
            ))

            # ---------- MAINTENANCE HISTORY ----------
            cur.execute("""
                INSERT INTO maintenance_history (
                    pcid,
                    asset_type,
                    asset_id,
                    action,
                    old_status,
                    new_status,
                    risk_level,
                    health_score,
                    performed_by,
                    remarks
                ) VALUES (
                    %s, %s, %s,
                    'Manual inspection completed',
                    %s,
                    'Available',
                    'Low',
                    100,
                    %s,
                    %s
                )
            """, (
                asset_id if route_asset_type == 'PC' else None,  # pcid
                history_asset_type,
                asset_id,                                 # accession_id for DEVICE
                old['status'],
                'System',
                'Marked as checked manually'
            ))

        conn.commit()
        return jsonify(success=True)

    except Exception as e:
        conn.rollback()
        return jsonify(success=False, error=str(e)), 500

    finally:
        conn.close()

def get_consumables_list(department_id=None, status=None, accountable=None,
                        item_name=None, brand_model=None,
                        quantity=None, acquisition_cost=None,
                        date_from=None, date_to=None):

    conn = get_db_connection()
    try:
        query = """
            SELECT 
                c.accession_id,
                c.item_name,
                c.category,
                c.brand,
                c.quantity,
                c.unit,
                c.department_id,
                dep.department_name,
                c.location,
                c.status,
                c.description,
                c.date_added,
                c.last_updated
            FROM consumables c
                        LEFT JOIN devices_full df ON df.accession_id = c.accession_id
            LEFT JOIN departments dep ON c.department_id = dep.department_id
            WHERE 1=1
                            AND (
                                        df.accession_id IS NULL
                                        OR TRIM(LOWER(df.device_type)) = 'consumable'
                                    )
                            AND COALESCE(c.is_archived, 0) = 0
        """
        params = []

        if department_id:
            query += " AND c.department_id = %s"
            params.append(department_id)

        if status:
            query += " AND c.status = %s"
            params.append(status)

        if accountable:
            query += " AND c.added_by LIKE %s"
            params.append(f"%{accountable}%")

        if item_name:
            query += " AND c.item_name LIKE %s"
            params.append(f"%{item_name}%")

        if brand_model:
            query += " AND c.brand LIKE %s"
            params.append(f"%{brand_model}%")

        if date_from and date_to:
            query += " AND c.date_added BETWEEN %s AND %s"
            params.extend([date_from, date_to])

        query += " ORDER BY c.accession_id DESC"

        with conn.cursor(pymysql.cursors.DictCursor) as cur:
            cur.execute(query, params)
            return cur.fetchall()

    finally:
        conn.close()
 
@manage_inventory_bp.route('/inventory/pc/bulk-damaged', methods=['POST'])
def bulk_damaged_pcs():
    data = request.get_json()

    pcids = data.get('pcids', [])
    damage_type = data.get('damage_type', 'General Damage')
    description = data.get('description', '')

    if not pcids:
        return jsonify(success=False, error="No PCs selected"), 400

    conn = get_db_connection()

    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:

            placeholders = ','.join(['%s'] * len(pcids))

            # Capture previous state first for accurate before/after history.
            cur.execute(
                f"""
                SELECT pcid, status, risk_level, health_score
                FROM pcinfofull
                WHERE pcid IN ({placeholders})
                """,
                tuple(pcids)
            )
            old_rows = cur.fetchall()
            old_map = {str(row['pcid']): row for row in old_rows}

            # ✅ 1. Update status and risk
            cur.execute(
                f"UPDATE pcinfofull SET status = 'Damaged', risk_level = 'High' WHERE pcid IN ({placeholders})",
                tuple(pcids)
            )

            # ✅ 2. Insert maintenance logs/history so History matches Manage PC changes.
            for pcid in pcids:
                old = old_map.get(str(pcid))
                prev_status = old['status'] if old else None
                prev_risk = old['risk_level'] if old else None
                prev_health = old['health_score'] if old else None

                cur.execute("""
                    INSERT INTO maintenance_logs (
                        asset_type,
                        asset_id,
                        previous_status,
                        new_status,
                        previous_risk_level,
                        new_risk_level,
                        action
                    ) VALUES (
                        'PC',
                        %s,
                        %s,
                        'Damaged',
                        %s,
                        'High',
                        'Bulk marked as damaged'
                    )
                """, (
                    pcid,
                    prev_status,
                    prev_risk
                ))

                cur.execute("""
                    INSERT INTO maintenance_history (
                        pcid,
                        asset_type,
                        asset_id,
                        action,
                        old_status,
                        new_status,
                        risk_level,
                        health_score,
                        performed_by,
                        remarks
                    ) VALUES (
                        %s, 'PC', %s,
                        'Bulk marked as damaged',
                        %s, 'Damaged',
                        'High', %s,
                        %s, %s
                    )
                """, (
                    pcid,
                    pcid,
                    prev_status,
                    prev_health,
                    'System',
                    description or 'Bulk marked as damaged'
                ))

            # ✅ 3. Insert reports (MATCHES YOUR TABLE)
            cur.execute(f"""
                INSERT INTO damage_reports (
                    pcid,
                    reported_by,
                    damage_type,
                    description
                )
                SELECT 
                    pcid,
                    'System',
                    %s,
                    %s
                FROM pcinfofull
                WHERE pcid IN ({placeholders})
            """, (
                damage_type,
                description,
                *pcids
            ))

        conn.commit()
        return jsonify(success=True)

    except Exception as e:
        conn.rollback()
        print(f"❌ Error: {e}")
        return jsonify(success=False, error=str(e)), 500

    finally:
        conn.close()
@manage_inventory_bp.route('/inventory/device-bulk-damaged', methods=['POST'])
def bulk_damaged_devices():
    data = request.get_json()

    device_ids = data.get('device_ids', [])
    damage_type = data.get('damage_type', 'General Damage')
    description = data.get('description', '')

    if not device_ids:
        return jsonify(success=False, error="No devices selected"), 400

    conn = get_db_connection()

    try:
        with conn.cursor(pymysql.cursors.DictCursor) as cur:

            placeholders = ','.join(['%s'] * len(device_ids))

            # Capture previous state first for accurate before/after history.
            cur.execute(
                f"""
                SELECT accession_id, status, risk_level, health_score
                FROM devices_full
                WHERE accession_id IN ({placeholders})
                """,
                tuple(device_ids)
            )
            old_rows = cur.fetchall()
            old_map = {str(row['accession_id']): row for row in old_rows}

            # 1️⃣ Update status and risk
            cur.execute(
                f"""
                UPDATE devices_full 
                SET status = 'Damaged', risk_level = 'High'
                WHERE accession_id  IN ({placeholders})
                """,
                tuple(device_ids)
            )

            # 2️⃣ Insert maintenance logs/history so History matches Manage Item changes.
            for accession_id in device_ids:
                old = old_map.get(str(accession_id))
                prev_status = old['status'] if old else None
                prev_risk = old['risk_level'] if old else None
                prev_health = old['health_score'] if old else None

                cur.execute("""
                    INSERT INTO maintenance_logs (
                        asset_type,
                        asset_id,
                        previous_status,
                        new_status,
                        previous_risk_level,
                        new_risk_level,
                        action
                    ) VALUES (
                        'DEVICE',
                        %s,
                        %s,
                        'Damaged',
                        %s,
                        'High',
                        'Bulk marked as damaged'
                    )
                """, (
                    accession_id,
                    prev_status,
                    prev_risk
                ))

                cur.execute("""
                    INSERT INTO maintenance_history (
                        pcid,
                        asset_type,
                        asset_id,
                        action,
                        old_status,
                        new_status,
                        risk_level,
                        health_score,
                        performed_by,
                        remarks
                    ) VALUES (
                        NULL, 'Device', %s,
                        'Bulk marked as damaged',
                        %s, 'Damaged',
                        'High', %s,
                        %s, %s
                    )
                """, (
                    accession_id,
                    prev_status,
                    prev_health,
                    'System',
                    description or 'Bulk marked as damaged'
                ))

            # 3️⃣ Insert damage reports
            cur.execute(
                f"""
                INSERT INTO device_damage_reports (
                    accession_id,
                    reported_by,
                    damage_type,
                    description
                )
                SELECT 
                    dev.accession_id,
                    'System',
                    %s,
                    %s
                FROM devices_full dev
                WHERE dev.accession_id IN ({placeholders})
                """,
                (
                    damage_type,
                    description,
                    *device_ids
                )
            )

        conn.commit()
        return jsonify(success=True)

    except Exception as e:
        conn.rollback()
        print(f"❌ Error: {e}")
        return jsonify(success=False, error=str(e)), 500

    finally:
        conn.close()