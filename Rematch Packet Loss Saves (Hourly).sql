SELECT
  hour,
  saves,
FROM
(
  SELECT
    FORMAT_TIMESTAMP('%Y-%m-%d %H', timestamp) AS hour,
    COUNT(DISTINCT session_id) AS sessions,
    COUNT(DISTINCT IF(next_rtt>0 AND next_packet_loss<=1 AND direct_packet_loss>=10, session_id, null)) AS saves,
  FROM
    `analytics.rematch_session_update` as session_summary
  WHERE
    timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 48 HOUR)
  GROUP BY
    hour
  ORDER BY
    hour
)