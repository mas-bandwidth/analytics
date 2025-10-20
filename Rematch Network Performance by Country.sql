SELECT
  country,
  COUNT(DISTINCT user_hash) AS players,
  AVG(direct_rtt) as direct_latency,
  AVG(IF(next_rtt>0 AND next_rtt<direct_rtt, next_rtt, direct_rtt)) as next_latency,
  AVG(direct_jitter) as direct_jitter,
  AVG(IF(next_rtt>0 AND next_jitter<direct_jitter, next_jitter, direct_jitter)) as next_jitter,
  AVG(real_jitter) as real_jitter,
  AVG(direct_packet_loss) as direct_packet_loss,
  AVG(IF(next_rtt>0 AND next_packet_loss<direct_packet_loss, next_packet_loss, direct_packet_loss)) as next_packet_loss,
  AVG(real_packet_loss) as real_packet_loss,
FROM
  `analytics.rematch_session_summary` as session_summary
INNER JOIN
  `analytics.rematch_session_update` AS session_update
ON
  session_summary.session_id = session_update.session_id
WHERE
  (session_update.timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY)) AND country IS NOT NULL AND country != "" AND likely_vpn_or_cross_region=FALSE
GROUP BY
  country
ORDER BY
  players DESC
