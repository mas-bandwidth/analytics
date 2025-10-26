SELECT
  FORMAT_TIMESTAMP('%Y-%m-%d', timestamp) AS day,
  COUNT(DISTINCT user_hash) AS players
FROM
  `analytics.session_summary`
WHERE
  (timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY))
  AND 
  (datacenter_id = -6970701343223852592) # i3d.dubai
GROUP BY
  day
ORDER BY
  day