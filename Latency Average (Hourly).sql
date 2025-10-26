WITH 
  total AS
  (
    SELECT
      FORMAT_TIMESTAMP('%Y-%m-%d %H', timestamp) AS hour,
      COUNT(*) as sample_count,
      SUM(direct_rtt) as direct_rtt,
      SUM(IF(next_rtt>0 AND next_rtt<direct_rtt,next_rtt,direct_rtt)) as next_rtt,
    FROM
      `analytics.session_update` as session_update
    WHERE
      session_update.timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 48 HOUR)
    GROUP BY
      hour
  )
SELECT
  hour,
  SUM(direct_rtt)/SUM(sample_count) as direct,
  SUM(next_rtt)/SUM(sample_count) as next,
FROM
  total  
GROUP BY
  hour
ORDER BY
  hour
