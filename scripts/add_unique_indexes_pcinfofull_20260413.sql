-- Migration: Add unique indexes to ensure serial uniqueness for PCs
-- WARNING: Run only after verifying there are no conflicting duplicate values in the table.
-- 1) Review duplicates (optional):
--    SELECT serial_no, COUNT(*) AS cnt FROM pcinfofull WHERE serial_no IS NOT NULL GROUP BY serial_no HAVING cnt > 1;
--    SELECT municipal_serial_no, COUNT(*) AS cnt FROM pcinfofull WHERE municipal_serial_no IS NOT NULL GROUP BY municipal_serial_no HAVING cnt > 1;
-- 2) To add unique indexes (MySQL):
ALTER TABLE pcinfofull
  ADD UNIQUE INDEX ux_pc_serial_no (serial_no),
  ADD UNIQUE INDEX ux_pc_municipal_serial_no (municipal_serial_no);

-- If you prefer to add indexes separately:
-- ALTER TABLE pcinfofull ADD UNIQUE INDEX ux_pc_serial_no (serial_no);
-- ALTER TABLE pcinfofull ADD UNIQUE INDEX ux_pc_municipal_serial_no (municipal_serial_no);

-- If either command fails due to duplicates, inspect and resolve duplicates first, then re-run.
