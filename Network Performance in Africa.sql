SELECT
  FORMAT_TIMESTAMP('%Y-%m-%d', session_summary.timestamp) AS day,
  COUNT(DISTINCT user_hash) AS players,
  AVG(direct_rtt) as direct_latency,
  AVG(IF(next_rtt>0 AND next_rtt<direct_rtt, next_rtt, direct_rtt)) as next_latency,
  AVG(direct_jitter) as direct_jitter,
  AVG(IF(next_rtt>0 AND next_jitter<direct_jitter, next_jitter, direct_jitter)) as next_jitter,
  AVG(real_jitter) as real_jitter,
  AVG(direct_packet_loss) as direct_packet_loss,
  AVG(IF(next_rtt>0 AND next_packet_loss<direct_packet_loss, next_packet_loss, direct_packet_loss)) as next_packet_loss,
  AVG(real_packet_loss) as real_packet_loss,
FROM
  `analytics.session_summary` as session_summary
INNER JOIN
  `analytics.session_update` AS session_update
ON
  session_summary.session_id = session_update.session_id
WHERE
  session_summary.timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY) AND
  (
		country="DZ" OR
		country="AO" OR
		country="BJ" OR
		country="BW" OR
		country="BF" OR
		country="BI" OR
		country="CM" OR
		country="CV" OR
		country="CF" OR
		country="TD" OR
		country="KM" OR
		country="CG" OR
		country="CD" OR
		country="CI" OR
		country="DJ" OR
		country="EG" OR
		country="GQ" OR
		country="ER" OR
		country="ET" OR
		country="GA" OR
		country="GM" OR
		country="GH" OR
		country="GN" OR
		country="GW" OR
		country="KE" OR
		country="LS" OR
		country="LR" OR
		country="LY" OR
		country="MG" OR
		country="ML" OR
		country="MW" OR
		country="MR" OR
		country="MU" OR
		country="YT" OR
		country="MA" OR
		country="MZ" OR
		country="NA" OR
		country="NE" OR
		country="NG" OR
		country="RE" OR
		country="RW" OR
		country="ST" OR
		country="SN" OR
		country="SC" OR
		country="SL" OR
		country="SO" OR
		country="ZA" OR
		country="SS" OR
		country="SD" OR
		country="SZ" OR
		country="TZ" OR
		country="TG" OR
		country="TN" OR
		country="UG" OR
		country="EH" OR
		country="ZM" OR
		country="ZW"
  )
GROUP BY
  day
ORDER BY
  day
