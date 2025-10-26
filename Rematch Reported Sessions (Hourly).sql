SELECT
  FORMAT_TIMESTAMP('%Y-%m-%d %H', timestamp) AS hour,
  COUNT(DISTINCT session_id) AS reported_sessions,
FROM
  `analytics.session_summary` as session_summary
WHERE
  timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 48 HOUR) AND reported
GROUP BY
  hour
ORDER BY
  hour
