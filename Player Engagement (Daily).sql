WITH player AS
(
  SELECT
    FORMAT_TIMESTAMP('%Y-%m-%d', timestamp) AS day,
    user_hash as player,
    CEIL(SUM(session_duration)/60.0) AS minutes_of_playtime,
  FROM
    `analytics.rematch_session_summary` as session_summary
  WHERE
    (timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY)) AND 
    session_duration > 60
  GROUP BY
    user_hash, day
)
SELECT
  day,
  AVG(minutes_of_playtime) as average_engagement_minutes,
FROM 
  player
GROUP BY
  day
ORDER BY
  day
