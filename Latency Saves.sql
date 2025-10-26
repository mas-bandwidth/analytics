SELECT
  saves,
FROM
(
  SELECT
    COUNT(DISTINCT session_id) AS sessions,
    COUNT(DISTINCT IF(best_latency_reduction>=100, session_id, null)) AS saves,
  FROM
  (
    SELECT
      session_id,    
      MAX(IF(next_rtt>0 AND next_rtt<direct_rtt, direct_rtt-next_rtt, 0)) as best_latency_reduction,
    FROM
      `analytics.session_update` as session_update
    WHERE
      timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY)
    GROUP BY
      session_id
  )
)
