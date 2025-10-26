SELECT 
  bad/(good+bad)*100 as percentage_bad
FROM (
    SELECT
    FORMAT_TIMESTAMP('%Y-%m-%d', timestamp) AS day,
    SUM(CASE WHEN (num_sessions>0 AND num_sessions < 6) OR num_sessions=7 OR num_sessions=9 THEN 10/3600.0 ELSE 0 END) bad,
    SUM(CASE WHEN num_sessions=6 OR num_sessions=8 OR num_sessions=10 THEN 10/3600.0 ELSE 0 END) good
  FROM
    `analytics.server_update`
  WHERE
    timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY)
  GROUP BY
    day
  ORDER BY
    day
);
