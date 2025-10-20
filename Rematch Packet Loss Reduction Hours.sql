  SELECT
    SUM(CASE WHEN packet_loss_reduction THEN 10.0/3600.0 ELSE 0.0 END) as hours,
  FROM
    `analytics.rematch_session_update` as session_update
  WHERE
    (timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY))
