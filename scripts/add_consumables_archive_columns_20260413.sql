-- Add archive columns for consumables
ALTER TABLE consumables
  ADD COLUMN is_archived TINYINT(1) DEFAULT 0,
  ADD COLUMN deleted_at DATETIME DEFAULT NULL;

-- NOTE: Run this against your database to enable archiving for consumables.
