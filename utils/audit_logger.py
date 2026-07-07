from flask import request
from datetime import datetime
from app import db
from models import InventoryAuditLog

def log_inventory_action(
    *,
    entity_type,
    entity_id,
    action,
    performed_by,
    field_name=None,
    old_value=None,
    new_value=None
):
    try:
        audit = InventoryAuditLog(
            entity_type=entity_type,
            entity_id=entity_id,
            action=action,
            field_name=field_name,
            old_value=str(old_value) if old_value is not None else None,
            new_value=str(new_value) if new_value is not None else None,
            performed_by=performed_by,
            performed_at=datetime.utcnow(),
            ip_address=request.remote_addr,
            user_agent=request.user_agent.string[:255]
        )

        db.session.add(audit)
        db.session.commit()

    except Exception as e:
        db.session.rollback()
        print("AUDIT LOG ERROR:", e)
