SELECT
  FORMAT_TIMESTAMP('%Y-%m-%d', timestamp) AS day,
  COUNT(DISTINCT session_id) AS reported_sessions,
FROM
  `analytics.session_summary` as session_summary
WHERE
  timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY) AND reported
GROUP BY
  day
ORDER BY
  day
