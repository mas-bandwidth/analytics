WITH 
  total AS
  (
    SELECT
      COUNT(DISTINCT user_hash) AS players,
    FROM
      `analytics.session_summary` as session_summary
    WHERE
      timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY)
  ),
  accelerated AS
  (
    SELECT
      COUNT(DISTINCT user_hash) AS players,
    FROM
      `analytics.session_summary` as session_summary
    INNER JOIN
      `analytics.session_update` AS session_update
    ON
      session_summary.session_id=session_update.session_id and session_summary.duration_on_next>0
    WHERE
      session_summary.timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY)
  )
SELECT 
  total.players as total_players,
  accelerated.players as accelerated_players,
  accelerated.players/total.players*100.0 as accelerated_percent
FROM
  total as total
INNER JOIN
  accelerated AS accelerated
ON
  1=1
