-- Migration: add `role` column to users table
-- Run this against your MySQL database to add the `role` column.
ALTER TABLE `users`
  ADD COLUMN `role` VARCHAR(50) DEFAULT 'staff' AFTER `is_admin`;

-- Backfill existing rows: set role = 'admin' where is_admin = 1
UPDATE `users` SET `role` = 'admin' WHERE `is_admin` = 1;
