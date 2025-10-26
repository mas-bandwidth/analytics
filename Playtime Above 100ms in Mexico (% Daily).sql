WITH 
  total AS
  (
    SELECT
      FORMAT_TIMESTAMP('%Y-%m-%d', session_summary.timestamp) AS day,
      SUM(CASE WHEN TRUE THEN 10.0/3600.0 END) as hours,
      SUM(CASE WHEN ( direct_rtt > 100 AND direct_rtt < 500 ) THEN 10.0/3600.0 END) as direct_hours_above_100ms,
      SUM(CASE WHEN ( IF(next_rtt>0, next_rtt, direct_rtt) > 100 AND IF(next_rtt>0, next_rtt, direct_rtt) < 500 ) THEN 10.0/3600.0 END) as next_hours_above_100ms,
    FROM
      `analytics.session_summary` as session_summary
    INNER JOIN
      `analytics.session_update` AS session_update
    ON
      session_summary.session_id = session_update.session_id
    WHERE
      (session_update.timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY)) AND country="MX" AND 
      (
        # virginia
        datacenter_id = -5214568859276043778 OR 
        datacenter_id = -2346230985471481226 OR
        datacenter_id = 4283406570687602836  OR
        datacenter_id = -6972449031730453238 OR 
        datacenter_id = -8671255208384590925 OR
        datacenter_id = 2441965983644586686  OR
        datacenter_id = 2441964884132958475  OR
        datacenter_id = 2441963784621330264  OR

        # dallas
        datacenter_id = -8794403082882271606 OR
        datacenter_id = 6208006259332915954  OR
        datacenter_id = -1128619725519678758 OR
        datacenter_id = -1128620825031306969 OR
        datacenter_id = -1128621924542935180 OR
        datacenter_id = 2891312839999596570  OR
        datacenter_id = 4465130889912859760  OR
        datacenter_id = 4458849287370356580  OR
        datacenter_id = 5381961764349284473  OR

        # los angeles
        datacenter_id = -4809343581467089110 OR
        datacenter_id = -7247488836840227406 OR
        datacenter_id = -5498307054037453406 OR
        datacenter_id = -5498308153549081617 OR
        datacenter_id = -5498309253060709828 OR
        datacenter_id = 7449150504045037914  OR
        datacenter_id = 4403292558316745120  OR
        datacenter_id = 2202096755744971830
      )
      AND likely_vpn_or_cross_region=FALSE
    GROUP BY
      day
  )
SELECT
  day,
  SUM(total.direct_hours_above_100ms) / SUM(total.hours) * 100.0 as direct_percent_above_100ms,
  SUM(total.next_hours_above_100ms) / SUM(total.hours) * 100.0 as next_percent_above_100ms,
FROM
  total  
GROUP BY
  day
ORDER BY
  day
