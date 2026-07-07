START TRANSACTION;

INSERT IGNORE INTO maintenance_history_backfill_20260402
SELECT mh.*
FROM maintenance_history mh
WHERE mh.action = 'Bulk surrender'
  AND COALESCE(mh.old_status, '') = 'Surrendered'
  AND COALESCE(mh.new_status, '') = 'Surrendered';

UPDATE maintenance_history mh
JOIN (
  SELECT
    mh_inner.id AS history_id,
    (
      SELECT ml.previous_status
      FROM maintenance_logs ml
      WHERE UPPER(TRIM(ml.asset_type)) = UPPER(TRIM(mh_inner.asset_type))
        AND ml.asset_id = mh_inner.asset_id
        AND ml.action = 'Bulk surrender'
        AND ml.new_status = 'Surrendered'
        AND ABS(TIMESTAMPDIFF(SECOND, ml.performed_at, mh_inner.performed_at)) <= 300
      ORDER BY ABS(TIMESTAMPDIFF(SECOND, ml.performed_at, mh_inner.performed_at))
      LIMIT 1
    ) AS fixed_old_status,
    (
      SELECT ml.previous_risk_level
      FROM maintenance_logs ml
      WHERE UPPER(TRIM(ml.asset_type)) = UPPER(TRIM(mh_inner.asset_type))
        AND ml.asset_id = mh_inner.asset_id
        AND ml.action = 'Bulk surrender'
        AND ml.new_status = 'Surrendered'
        AND ABS(TIMESTAMPDIFF(SECOND, ml.performed_at, mh_inner.performed_at)) <= 300
      ORDER BY ABS(TIMESTAMPDIFF(SECOND, ml.performed_at, mh_inner.performed_at))
      LIMIT 1
    ) AS fixed_risk_level
  FROM maintenance_history mh_inner
  WHERE mh_inner.action = 'Bulk surrender'
    AND COALESCE(mh_inner.old_status, '') = 'Surrendered'
    AND COALESCE(mh_inner.new_status, '') = 'Surrendered'
) fix ON fix.history_id = mh.id
SET
  mh.old_status = COALESCE(fix.fixed_old_status, mh.old_status),
  mh.risk_level = COALESCE(fix.fixed_risk_level, mh.risk_level)
WHERE fix.fixed_old_status IS NOT NULL OR fix.fixed_risk_level IS NOT NULL;

INSERT INTO maintenance_history (
  pcid, asset_type, asset_id, action, old_status, new_status,
  risk_level, health_score, performed_by, remarks, performed_at
)
SELECT
  CASE WHEN UPPER(TRIM(ml.asset_type)) = 'PC' THEN pc.pcid ELSE NULL END AS pcid,
  CASE WHEN UPPER(TRIM(ml.asset_type)) = 'DEVICE' THEN 'Device' ELSE 'PC' END AS asset_type,
  ml.asset_id,
  ml.action,
  ml.previous_status,
  ml.new_status,
  CASE
    WHEN LOWER(TRIM(ml.new_status)) IN ('damaged', 'damage', 'unusable') THEN 'High'
    WHEN ml.new_risk_level IS NULL OR TRIM(ml.new_risk_level) = '' THEN NULL
    ELSE ml.new_risk_level
  END AS risk_level,
  NULL AS health_score,
  COALESCE(ml.performed_by, 'System') AS performed_by,
  COALESCE(ml.remarks, CONCAT('Backfilled from maintenance_logs on ', DATE_FORMAT(NOW(), '%Y-%m-%d'))) AS remarks,
  ml.performed_at
FROM maintenance_logs ml
LEFT JOIN pcinfofull pc
  ON UPPER(TRIM(ml.asset_type)) = 'PC'
 AND ml.asset_id = pc.pcid
WHERE ml.action IN ('Bulk surrender', 'Bulk status update', 'Bulk inspection completed', 'Manual inspection completed', 'Bulk marked as damaged')
  AND NOT EXISTS (
    SELECT 1
    FROM maintenance_history mh
    WHERE UPPER(TRIM(mh.asset_type)) = UPPER(TRIM(ml.asset_type))
      AND mh.asset_id = ml.asset_id
      AND mh.action = ml.action
      AND mh.old_status <=> ml.previous_status
      AND mh.new_status <=> ml.new_status
      AND mh.performed_at = ml.performed_at
  );

COMMIT;

SELECT COUNT(*) AS wrong_surrender_rows_after
FROM maintenance_history
WHERE action = 'Bulk surrender'
  AND COALESCE(old_status, '') = 'Surrendered'
  AND COALESCE(new_status, '') = 'Surrendered';

SELECT COUNT(*) AS missing_from_logs_after
FROM maintenance_logs ml
WHERE ml.action IN ('Bulk surrender', 'Bulk status update', 'Bulk inspection completed', 'Manual inspection completed', 'Bulk marked as damaged')
  AND NOT EXISTS (
    SELECT 1
    FROM maintenance_history mh
    WHERE UPPER(TRIM(mh.asset_type)) = UPPER(TRIM(ml.asset_type))
      AND mh.asset_id = ml.asset_id
      AND mh.action = ml.action
      AND mh.old_status <=> ml.previous_status
      AND mh.new_status <=> ml.new_status
      AND mh.performed_at = ml.performed_at
  );
