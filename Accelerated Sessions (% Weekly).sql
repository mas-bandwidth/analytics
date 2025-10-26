SELECT
  week,
  SUM(accelerated_sessions)/SUM(total_sessions)*100.0 as accelerated_percent,
FROM
(
SELECT
  EXTRACT(ISOWEEK FROM timestamp) as week,
  COUNT(DISTINCT session_id) AS total_sessions,
  COUNT(DISTINCT IF(duration_on_next>0, session_id, NULL)) AS accelerated_sessions,
FROM
  `analytics.session_summary` as session_summary
WHERE
  timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY)
GROUP BY
  week
)
GROUP BY
  week
ORDER BY
  week
