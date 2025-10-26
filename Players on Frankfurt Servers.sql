SELECT
  FORMAT_TIMESTAMP('%Y-%m-%d', timestamp) AS day,
  COUNT(DISTINCT user_hash) AS players
FROM
  `analytics.session_summary`
WHERE
  (timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY))
  AND 
  ( 
    datacenter_id = -1955387185768469208 OR 
    datacenter_id = -5522283100318941376 OR 
    datacenter_id = 7432198028711771166  OR 
    datacenter_id = 3321765873280093717  OR 
    datacenter_id = 3830768155627315109  OR 
    datacenter_id = -4297481183583574057
  )
GROUP BY
  day
ORDER BY
  day