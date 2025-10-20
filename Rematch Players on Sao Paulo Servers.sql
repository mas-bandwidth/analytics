SELECT
  FORMAT_TIMESTAMP('%Y-%m-%d', timestamp) AS day,
  COUNT(DISTINCT user_hash) AS players
FROM
  `analytics.rematch_session_summary`
WHERE
  (timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY)) AND 
  (
    datacenter_id = 5415960973531970909 OR # latitude.saopaulo
    datacenter_id = 5507732127557945653 OR # google.saopaulo.1
    datacenter_id = 5507728829023061020 OR # google.saopaulo.2
    datacenter_id = 5507729928534689231    # google.saopaulo.3
  )
GROUP BY
  day
ORDER BY
  day