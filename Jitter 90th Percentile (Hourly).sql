SELECT
  FORMAT_TIMESTAMP('%Y-%m-%d %H', timestamp) AS hour,
  APPROX_QUANTILES(direct_jitter, 100)[OFFSET(90)] as direct,
  APPROX_QUANTILES(IF(next_rtt>0,next_jitter,direct_jitter), 100)[OFFSET(90)] as next,
  APPROX_QUANTILES(real_jitter, 100)[OFFSET(90)] as real,
FROM
  `analytics.session_update` as session_update
WHERE
  session_update.timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 48 HOUR)
GROUP BY
  hour
ORDER BY
  hour
