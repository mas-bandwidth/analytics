SELECT
  FORMAT_TIMESTAMP('%Y-%m-%d', timestamp) AS day,
  SUM(session_duration/3600.0) AS hours_of_playtime,
FROM
  `analytics.session_summary` as session_summary
WHERE
  (session_summary.timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY))
GROUP BY
    day
ORDER BY
    day
