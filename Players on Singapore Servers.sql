SELECT
  FORMAT_TIMESTAMP('%Y-%m-%d', timestamp) AS day,
  COUNT(DISTINCT user_hash) AS players
FROM
  `analytics.session_summary`
WHERE
  (timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY)) AND 
  ( datacenter_id = 2351951396152244755 )
GROUP BY
  day
ORDER BY
  day