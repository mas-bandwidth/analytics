SELECT
  week,
  short_sessions/total_sessions*100.0 as percent_short
FROM
(
  SELECT
    EXTRACT(ISOWEEK FROM timestamp) as week,
    COUNT(DISTINCT(session_id)) as total_sessions,
    COUNT(DISTINCT IF(session_duration<60, session_id, NULL)) as short_sessions,
  FROM
    `analytics.session_summary`
  WHERE
    timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY) and fallback_to_direct IS NOT TRUE
  GROUP BY
    week
  ORDER BY
    week
)