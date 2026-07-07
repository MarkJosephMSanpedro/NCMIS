from app import db

class InventoryAuditLog(db.Model):
    __tablename__ = 'inventory_audit_log'

    audit_id = db.Column(db.BigInteger, primary_key=True)

    entity_type = db.Column(db.Enum('PC', 'DEVICE'), nullable=False)
    entity_id = db.Column(db.Integer, nullable=False)

    action = db.Column(db.Enum(
        'CREATE',
        'UPDATE',
        'DELETE',
        'SOFT_DELETE',
        'RESTORE',
        'BULK_UPDATE',
        'STATUS_CHANGE',
        'MAINTENANCE',
        'CHECKED'
    ), nullable=False)

    field_name = db.Column(db.String(100))
    old_value = db.Column(db.Text)
    new_value = db.Column(db.Text)

    performed_by = db.Column(db.Integer, nullable=False)
    performed_at = db.Column(db.DateTime, nullable=False)

    ip_address = db.Column(db.String(45))
    user_agent = db.Column(db.String(255))
