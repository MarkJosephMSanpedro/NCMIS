-- Add archive columns to pcinfofull
ALTER TABLE pcinfofull ADD COLUMN is_archived TINYINT(1) DEFAULT 0, ADD COLUMN deleted_at DATETIME DEFAULT NULL;

-- Add archive columns to devices_full
ALTER TABLE devices_full ADD COLUMN is_archived TINYINT(1) DEFAULT 0, ADD COLUMN deleted_at DATETIME DEFAULT NULL;
