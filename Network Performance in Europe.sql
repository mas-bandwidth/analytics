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
  (session_summary.timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY)) AND
  (
    country="AT" OR
    country="BE" OR
    country="BG" OR
    country="HR" OR
    country="CY" OR
    country="CZ" OR
    country="DK" OR
    country="EE" OR
    country="FI" OR
    country="FR" OR
    country="DE" OR
    country="GR" OR
    country="HU" OR
    country="IE" OR
    country="IT" OR
    country="LV" OR
    country="LT" OR
    country="LU" OR
    country="MT" OR
    country="NL" OR
    country="PL" OR
    country="PT" OR
    country="RO" OR
    country="SK" OR
    country="SI" OR
    country="ES" OR
    country="SE" OR
    country="GB" OR
    country="AD" OR
    country="IS" OR
    country="LI" OR
    country="MC" OR
    country="NO" OR
    country="SM" OR
    country="CH" OR
    country="VA"
  )
GROUP BY
  day
ORDER BY
  day
