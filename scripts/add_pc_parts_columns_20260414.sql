-- Migration: add mouse and keyboard columns to pcinfofull
-- Run this on the database to add the new PC part columns used by the UI/backend.

ALTER TABLE `pcinfofull`
  ADD COLUMN IF NOT EXISTS `mouse` varchar(255) DEFAULT NULL,
  ADD COLUMN IF NOT EXISTS `keyboard` varchar(255) DEFAULT NULL;

-- End
