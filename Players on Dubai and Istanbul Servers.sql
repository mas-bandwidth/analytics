SELECT
  FORMAT_TIMESTAMP('%Y-%m-%d', timestamp) AS day,
  COUNT(DISTINCT user_hash) AS players
FROM
  `analytics.session_summary`
WHERE
  (timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY))
  AND 
  ( 
    datacenter_id = -6970701343223852592 OR # i3d.dubai
    datacenter_id = 341395253430349299   OR # google.doha.1
    datacenter_id = 341396352941977510   OR # google.doha.2
    datacenter_id = 341397452453605721   OR # google.doha.3
    datacenter_id = -7296963921440880105 OR # gcore.istanbul
    datacenter_id = 9002401413943035999     # datapacket.istanbul
  )
GROUP BY
  day
ORDER BY
  day