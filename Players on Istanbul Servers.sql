SELECT
  FORMAT_TIMESTAMP('%Y-%m-%d', timestamp) AS day,
  COUNT(DISTINCT user_hash) AS players
FROM
  `analytics.session_summary`
WHERE
  (timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY)) AND 
  ( datacenter_id = 9002401413943035999 OR datacenter_id = -7296963921440880105)
GROUP BY
  day
ORDER BY
  day