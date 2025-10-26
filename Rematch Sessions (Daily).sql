SELECT
  FORMAT_TIMESTAMP("%Y-%m-%d", timestamp) as day,
  COUNT(DISTINCT(session_id)) as sessions,
FROM
  `analytics.session_summary`
WHERE
  timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY)
GROUP BY
  day
ORDER BY
  day