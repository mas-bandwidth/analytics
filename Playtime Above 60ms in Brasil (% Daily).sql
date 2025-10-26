WITH 
  total AS
  (
    SELECT
      FORMAT_TIMESTAMP('%Y-%m-%d', session_summary.timestamp) AS day,
      SUM(CASE WHEN TRUE THEN 10.0/3600.0 END) as hours,
      SUM(CASE WHEN ( direct_rtt > 60 AND direct_rtt < 500 ) THEN 10.0/3600.0 END) as direct_hours_above_60ms,
      SUM(CASE WHEN ( IF(next_rtt>0, next_rtt, direct_rtt) > 60 AND IF(next_rtt>0, next_rtt, direct_rtt) < 500 ) THEN 10.0/3600.0 END) as next_hours_above_60ms,
    FROM
      `analytics.rematch_session_summary` as session_summary
    INNER JOIN
      `analytics.rematch_session_update` AS session_update
    ON
      session_summary.session_id = session_update.session_id
    WHERE
      (session_summary.timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY)) AND country="BR" AND datacenter_id=5415960973531970909 AND likely_vpn_or_cross_region=FALSE
    GROUP BY
      day
  )
SELECT
  day,
  SUM(total.direct_hours_above_60ms) / SUM(total.hours) * 100.0 as direct_percent_above_60ms,
  SUM(total.next_hours_above_60ms) / SUM(total.hours) * 100.0 as next_percent_above_60ms,
FROM
  total  
GROUP BY
  day
ORDER BY
  day