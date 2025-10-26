SELECT
  FORMAT_TIMESTAMP('%Y-%m-%d', timestamp) AS day,
  APPROX_QUANTILES(direct_jitter, 100)[OFFSET(90)] as direct,
  APPROX_QUANTILES(IF(next_rtt>0,next_jitter,direct_jitter), 100)[OFFSET(90)] as next,
  APPROX_QUANTILES(real_jitter, 100)[OFFSET(90)] as real,
FROM
  `analytics.rematch_session_update` as session_update
WHERE
  timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY)
GROUP BY
  day
ORDER BY
  day
