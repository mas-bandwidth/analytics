SELECT
  EXTRACT(ISOWEEK FROM timestamp) as week,
  COUNT(DISTINCT(session_id)) as sessions,
FROM
  `analytics.session_summary`
WHERE
  (timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY))
GROUP BY
  week
ORDER BY
  week