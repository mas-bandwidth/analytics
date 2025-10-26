SELECT
  day,
  short_sessions/total_sessions*100.0 as percent_short
FROM
(
  SELECT
    FORMAT_TIMESTAMP("%Y-%m-%d", timestamp) as day,
    COUNT(DISTINCT(session_id)) as total_sessions,
    COUNT(DISTINCT IF(session_duration<60, session_id, NULL)) as short_sessions,
  FROM
    `analytics.session_summary`
  WHERE
    timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY) and fallback_to_direct IS NOT TRUE
  GROUP BY
    day
  ORDER BY
    day
)