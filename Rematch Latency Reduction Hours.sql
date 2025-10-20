  SELECT
    ROUND(SUM(CASE WHEN (direct_rtt-next_rtt) >= 0 AND (direct_rtt-next_rtt) <= 10 THEN 10.0/3600.0 ELSE 0.0 END)) as packet_loss_reduction,
    ROUND(SUM(CASE WHEN (direct_rtt-next_rtt) >= 10 AND (direct_rtt-next_rtt) <= 25 THEN 10.0/3600.0 ELSE 0.0 END)) as hours_10_25,
    ROUND(SUM(CASE WHEN (direct_rtt-next_rtt) >= 25 AND (direct_rtt-next_rtt) <= 50 THEN 10.0/3600.0 ELSE 0.0 END)) as hours_25_50,
    ROUND(SUM(CASE WHEN (direct_rtt-next_rtt) >= 50 AND (direct_rtt-next_rtt) <= 100 THEN 10.0/3600.0 ELSE 0.0 END)) as hours_50_100,
    ROUND(SUM(CASE WHEN (direct_rtt-next_rtt) >= 100 THEN 10.0/3600.0 ELSE 0.0 END)) as hours_100plus,
  FROM
    `analytics.rematch_session_update` as session_update
  WHERE
    (session_update.timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY)) AND session_update.next_rtt>0