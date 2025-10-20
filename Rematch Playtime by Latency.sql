WITH 
  total AS
  (
    SELECT
      FORMAT_TIMESTAMP('%Y-%m-%d', session_summary.timestamp) AS day,
      SUM(CASE WHEN IF(next_rtt>0, next_rtt, direct_rtt) < 500 THEN 10.0/3600.0 END) as hours,
      SUM(CASE WHEN ( IF(next_rtt>0, next_rtt, direct_rtt) >= 0 AND IF(next_rtt>0, next_rtt, direct_rtt) <= 20 ) THEN 10.0/3600.0 END) as hours_0_20,
      SUM(CASE WHEN ( IF(next_rtt>0, next_rtt, direct_rtt) >= 20 AND IF(next_rtt>0, next_rtt, direct_rtt) <= 40 ) THEN 10.0/3600.0 END) as hours_20_40,
      SUM(CASE WHEN ( IF(next_rtt>0, next_rtt, direct_rtt) >= 40 AND IF(next_rtt>0, next_rtt, direct_rtt) <= 60 ) THEN 10.0/3600.0 END) as hours_40_60,
      SUM(CASE WHEN ( IF(next_rtt>0, next_rtt, direct_rtt) >= 60 AND IF(next_rtt>0, next_rtt, direct_rtt) <= 80 ) THEN 10.0/3600.0 END) as hours_60_80,
      SUM(CASE WHEN ( IF(next_rtt>0, next_rtt, direct_rtt) >= 80 AND IF(next_rtt>0, next_rtt, direct_rtt) <= 100 ) THEN 10.0/3600.0 END) as hours_80_100,
      SUM(CASE WHEN ( IF(next_rtt>0, next_rtt, direct_rtt) >= 100 AND IF(next_rtt>0, next_rtt, direct_rtt) < 500 ) THEN 10.0/3600.0 END) as hours_100_plus,
    FROM
      `analytics.rematch_session_summary` as session_summary
    INNER JOIN
      `analytics.rematch_session_update` AS session_update
    ON
      session_summary.session_id = session_update.session_id
    WHERE
      (session_update.timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY)) AND
      session_summary.likely_vpn_or_cross_region=FALSE AND
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
  SUM(total.hours_0_20) / SUM(total.hours) * 100.0 as percent_0_20ms,
  SUM(total.hours_20_40) / SUM(total.hours) * 100.0 as percent_20_40ms,
  SUM(total.hours_40_60) / SUM(total.hours) * 100.0 as percent_40_60ms,
  SUM(total.hours_60_80) / SUM(total.hours) * 100.0 as percent_60_80ms,
  SUM(total.hours_80_100) / SUM(total.hours) * 100.0 as percent_80_100ms,
  SUM(total.hours_100_plus) / SUM(total.hours) * 100.0 as percent_100_plus,
FROM
  total  
GROUP BY
  day
ORDER BY
  day
