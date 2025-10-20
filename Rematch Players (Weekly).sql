SELECT
  EXTRACT(ISOWEEK FROM timestamp) as week,
  COUNT(DISTINCT user_hash) AS players,
FROM
  `analytics.rematch_session_summary`
WHERE
  (timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY))
GROUP BY
  week
ORDER BY
  week