WITH 
  total AS
  (
    SELECT
      FORMAT_TIMESTAMP('%Y-%m-%d %H', timestamp) AS hour,
      COUNT(*) as sample_count,
      COUNT(IF(next_rtt>0,1,0)) as next_sample_count,
      SUM(direct_packet_loss) as direct_packet_loss,
      SUM(IF(next_rtt>0,next_packet_loss,0)) as next_packet_loss,
      SUM(real_packet_loss) as real_packet_loss,
    FROM
      `analytics.session_update` as session_update
    WHERE
      timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 48 HOUR)
    GROUP BY
      hour
  )
SELECT
  hour,
  SUM(direct_packet_loss)/SUM(sample_count) as direct,
  SUM(next_packet_loss)/SUM(next_sample_count) as next,
  SUM(real_packet_loss)/SUM(sample_count) as real,
FROM
  total  
GROUP BY
  hour
ORDER BY
  hour
