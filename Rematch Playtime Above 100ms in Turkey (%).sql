WITH 
  total AS
  (
    SELECT
      SUM(CASE WHEN TRUE THEN 10.0/3600.0 ELSE 0.0 END) as hours,
      SUM(CASE WHEN ( direct_rtt > 100 AND direct_rtt < 500 ) THEN 10.0/3600.0 ELSE 0.0 END) as direct_hours_above_100ms,
      SUM(CASE WHEN ( IF(next_rtt>0, next_rtt, direct_rtt) > 100 AND IF(next_rtt>0, next_rtt, direct_rtt) < 500 ) THEN 10.0/3600.0 ELSE 0.0 END) as next_hours_above_100ms,
    FROM
      `analytics.rematch_session_summary` as session_summary
    INNER JOIN
      `analytics.rematch_session_update` AS session_update
    ON
      session_summary.session_id = session_update.session_id
    WHERE
      (session_summary.timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY)) AND country="TR" AND (datacenter_id=-7296963921440880105 OR datacenter_id=9002401413943035999) AND likely_vpn_or_cross_region=FALSE
  )
SELECT
  SUM(total.direct_hours_above_100ms) / SUM(total.hours) * 100.0 as direct_percent_above_100ms,
  SUM(total.next_hours_above_100ms) / SUM(total.hours) * 100.0 as next_percent_above_100ms,
FROM
  total  
