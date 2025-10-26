SELECT
  FORMAT_TIMESTAMP('%Y-%m-%d', timestamp) AS day,
  APPROX_QUANTILES(direct_rtt, 100)[OFFSET(90)] as direct,
  APPROX_QUANTILES(IF(next_rtt>0 AND next_rtt<direct_rtt, next_rtt, direct_rtt), 100)[OFFSET(90)] as next,
FROM
  `analytics.session_update` as session_update
WHERE
  (timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY))
GROUP BY
  day
