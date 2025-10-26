WITH 
  total AS
  (
    SELECT
      FORMAT_TIMESTAMP('%Y-%m-%d', session_summary.timestamp) AS day,
      SUM(CASE WHEN TRUE THEN 10.0/3600.0 END) as hours,
      SUM(CASE WHEN ( direct_rtt > 100 AND direct_rtt < 500 ) THEN 10.0/3600.0 END) as direct_hours_above_100ms,
      SUM(CASE WHEN ( IF(next_rtt>0, IF(next_rtt<direct_rtt,next_rtt,direct_rtt), direct_rtt) > 100 AND IF(next_rtt>0, next_rtt, direct_rtt) < 500 ) THEN 10.0/3600.0 END) as next_hours_above_100ms,
    FROM
      `analytics.rematch_session_summary` as session_summary
    INNER JOIN
      `analytics.rematch_session_update` AS session_update
    ON
      session_summary.session_id = session_update.session_id
    WHERE
      (session_update.timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY)) AND session_summary.likely_vpn_or_cross_region=FALSE AND
      (
        datacenter_id != 6062399594931820931 AND # serversaustralia.sydney
        datacenter_id != 2351951396152244755 AND # i3d.singapore
        datacenter_id != 1899670019123575523 AND # google.tokyo.1
        datacenter_id != 1899671118635203734 AND # google.tokyo.2
        datacenter_id != 1899672218146831945 AND # google.tokyo.3
        datacenter_id != 8571118839446833363     # gcore.johannesburg
      )      
    GROUP BY
      day
  )
SELECT
  day,
  SUM(total.direct_hours_above_100ms) / SUM(total.hours) * 100.0 as direct,
  SUM(total.next_hours_above_100ms) / SUM(total.hours) * 100.0 as next,
FROM
  total  
GROUP BY
  day
ORDER BY
  day
