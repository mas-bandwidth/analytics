SELECT
  country,
  COUNT(user_hash) as players
FROM
  `analytics.session_summary`
WHERE
  (timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY)) AND country IS NOT NULL AND country != ""
GROUP BY
  country
ORDER BY
  players DESC
