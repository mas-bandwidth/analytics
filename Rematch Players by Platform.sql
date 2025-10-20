SELECT
  COUNT(DISTINCT IF(platform_type=1, user_hash, NULL)) AS pc,
  COUNT(DISTINCT IF(platform_type=8, user_hash, NULL)) AS xbox,
  COUNT(DISTINCT IF(platform_type=9, user_hash, NULL)) AS ps5
FROM
  `analytics.rematch_session_summary`
WHERE
  (timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY))
