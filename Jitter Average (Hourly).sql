WITH 
  total AS
  (
    SELECT
      FORMAT_TIMESTAMP('%Y-%m-%d %H', timestamp) AS hour,
      COUNT(*) as sample_count,
      COUNTIF(next_rtt>0) as next_sample_count,
      SUM(direct_jitter) as direct_jitter,
      SUM(CASE WHEN next_rtt>0 THEN next_jitter ELSE 0.0 END) as next_jitter,
      SUM(real_jitter) as real_jitter,
    FROM
      `analytics.session_update` as session_update
    WHERE
      session_update.timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 48 HOUR)
    GROUP BY
      hour
  )
SELECT
  hour,
  SUM(direct_jitter)/SUM(sample_count) as direct,
  SUM(next_jitter)/SUM(sample_count) as next,
  SUM(real_jitter)/SUM(sample_count) as real,
FROM
  total  
GROUP BY
  hour
ORDER BY
  hour
