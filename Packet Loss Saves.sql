SELECT
  saves,
FROM
(
  SELECT
    COUNT(DISTINCT session_id) AS sessions,
    COUNT(DISTINCT IF(next_rtt>0 AND next_packet_loss<1 AND direct_packet_loss>10, session_id, null)) AS saves,
  FROM
    `analytics.session_update` as session_summary
  WHERE
    timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY)
)