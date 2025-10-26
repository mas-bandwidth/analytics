SELECT
  hour,
  likely_vpn_sessions / total_sessions * 100.0 as likely_vpn_session_percent,
FROM
(
  SELECT
    FORMAT_TIMESTAMP("%Y-%m-%d %H", timestamp) as hour,
    COUNT(DISTINCT(session_id)) as total_sessions,
    COUNT(DISTINCT IF(likely_vpn_or_cross_region=TRUE, session_id, NULL)) as likely_vpn_sessions,
  FROM
    `analytics.rematch_session_summary`
  WHERE
    timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 48 HOUR) AND 
    likely_vpn_or_cross_region IS NOT NULL
  GROUP BY
    hour
  ORDER BY
    hour
)