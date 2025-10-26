SELECT
  hour,
  SUM(accelerated_sessions)/SUM(total_sessions)*100.0 as accelerated_percent,
FROM
(
SELECT
  FORMAT_TIMESTAMP('%Y-%m-%d %H', timestamp) AS hour,
  COUNT(DISTINCT session_id) AS total_sessions,
  COUNT(DISTINCT IF(duration_on_next>0, session_id, NULL)) AS accelerated_sessions,
FROM
  `analytics.session_summary` as session_summary
WHERE
  timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 48 HOUR)
GROUP BY
  hour
)
GROUP BY
  hour
ORDER BY
  hour
