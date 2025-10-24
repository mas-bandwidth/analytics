SELECT 
  bad/(good+bad)*100 as percentage_bad
FROM (
  SELECT
    DISTINCT(server_init.match_id),
    FORMAT_TIMESTAMP('%Y-%m-%d', server_init.timestamp) AS day,
    SUM(CASE WHEN (num_sessions>0 AND num_sessions < 6) OR num_sessions=7 OR num_sessions=9 THEN 10/3600.0 ELSE 0 END) bad,
    SUM(CASE WHEN num_sessions=6 OR num_sessions=8 OR num_sessions=10 THEN 10/3600.0 ELSE 0 END) good
  FROM
    `analytics.rematch_server_init` AS server_init
  INNER JOIN
    `analytics.rematch_server_update` as server_update
  ON
    server_init.match_id = server_update.match_id
  WHERE
    server_init.timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 7 DAY) AND server_init.match_id IS NOT NULL AND ABS(TIMESTAMP_DIFF(server_init.timestamp, server_update.timestamp, SECOND)) <= 60.0
  GROUP BY
    day, match_id
  ORDER BY
    day
);
