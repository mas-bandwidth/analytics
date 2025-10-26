WITH 
  total AS
  (
    SELECT
      FORMAT_TIMESTAMP('%Y-%m-%d', timestamp) AS day,
      COUNT(*) as sample_count,
      SUM(direct_rtt) as direct_rtt,
      SUM(IF(next_rtt>0 AND next_rtt<direct_rtt,next_rtt,direct_rtt)) as next_rtt,
    FROM
      `analytics.rematch_session_update` as session_update
    WHERE
      (session_update.timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY))
    GROUP BY
      day
  )
SELECT
  day,
  SUM(direct_rtt)/SUM(sample_count) as direct,
  SUM(next_rtt)/SUM(sample_count) as next,
FROM
  total  
GROUP BY
  day
ORDER BY
  day
