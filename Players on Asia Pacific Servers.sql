SELECT
  FORMAT_TIMESTAMP('%Y-%m-%d', timestamp) AS day,
  COUNT(DISTINCT user_hash) AS user_count
FROM
  `analytics.session_summary`
WHERE
  (timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY)) 
  AND 
  ( 
    datacenter_id = 6062399594931820931 OR # serversaustralia.sydney
    datacenter_id = 2351951396152244755 OR # i3d.singapore
    datacenter_id = 1899670019123575523 OR # google.tokyo.1
    datacenter_id = 1899671118635203734 OR # google.tokyo.2
    datacenter_id = 1899672218146831945.   # google.tokyo.3
  )
GROUP BY
    day
ORDER BY
    day