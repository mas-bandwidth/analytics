WITH player AS
(
  SELECT
    CASE

      WHEN 
      (
        country="US" OR country="CA" OR country="MX"
      ) 
      THEN 'north america'

      WHEN 
      (
        country="AU" OR
        country="CN" OR
        country="FJ" OR
        country="ID" OR
        country="JP" OR
        country="MY" OR
        country="NZ" OR
        country="PG" OR
        country="PH" OR
        country="SG" OR
        country="KR" OR
        country="TH" OR
        country="VN" OR
        country="HK"
      )
      THEN 'asia pacific'  

      WHEN 
      (
        country="AR" OR
        country="BO" OR
        country="BR" OR
        country="CL" OR
        country="CO" OR
        country="EC" OR
        country="GY" OR
        country="EC" OR
        country="GY" OR
        country="PY" OR
        country="PE" OR
        country="SR" OR
        country="UY" OR
        country="VE"
      )
      THEN 'south america'

      WHEN 
      (
        country="BZ" OR
        country="CR" OR
        country="SV" OR
        country="GT" OR
        country="HN" OR
        country="NI" OR
        country="PA" OR
        country="AI" OR
        country="AG" OR
        country="AW" OR
        country="BS" OR
        country="BB" OR
        country="BM" OR
        country="VG" OR
        country="KY" OR
        country="CU" OR
        country="DM" OR
        country="DO" OR
        country="GD" OR
        country="HT" OR
        country="JM" OR
        country="MQ" OR
        country="MS" OR
        country="AN" OR
        country="KN" OR
        country="LC" OR
        country="VC" OR
        country="SX" OR
        country="TT" OR
        country="TC"
      )
      THEN 'central american and caribbean'

      WHEN
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
      THEN 'europe'

      WHEN 
        country="AE" OR
        country="AF" OR
        country="BH" OR
        country="EG" OR
        country="IR" OR
        country="IQ" OR
        country="IL" OR
        country="JO" OR
        country="KW" OR
        country="LB" OR
        country="OM" OR
        country="QA" OR
        country="SA" OR
        country="SY" OR
        country="TR" OR
        country="YE"
      THEN 'middle east and istanbul'
      
      WHEN
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
      THEN 'africa'

      ELSE 'other'

    END AS region,

    FORMAT_TIMESTAMP('%Y-%m-%d', timestamp) AS day,
    user_hash as player,
    SUM(session_duration/60.0) AS minutes_of_playtime,
  FROM
    `analytics.session_summary` as session_summary
  WHERE
    (timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY)) AND
    session_duration > 0 AND 
    country IS NOT NULL
  GROUP BY
    day, user_hash, region
)
SELECT
  region,
  AVG(minutes_of_playtime) as engagement
FROM 
  player
WHERE
  region!='other'
GROUP BY
  player.region
ORDER BY
  engagement DESC
