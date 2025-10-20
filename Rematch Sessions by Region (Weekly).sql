SELECT

  EXTRACT(ISOWEEK FROM timestamp) as week,

  COUNT
  (
    DISTINCT IF
    (
      datacenter_id = 6062399594931820931 OR # serversaustralia.sydney
      datacenter_id = 2351951396152244755 OR # i3d.singapore
      datacenter_id = 1899670019123575523 OR # google.tokyo.1
      datacenter_id = 1899671118635203734 OR # google.tokyo.2
      datacenter_id = 1899672218146831945    # google.tokyo.3
      , 
      session_id, 
      NULL
    )
  ) AS asia_pacific,

  COUNT
  (
    DISTINCT IF
    (
      datacenter_id = -6970701343223852592 OR # i3d.dubai
      datacenter_id = 341395253430349299   OR # google.doha.1
      datacenter_id = 341396352941977510   OR # google.doha.2
      datacenter_id = 341397452453605721   OR # google.doha.3
      datacenter_id = -7296963921440880105 OR # gcore.istanbul
      datacenter_id = 9002401413943035999     # datapacket.istanbul
      ,
      session_id, 
      NULL
    )
  ) AS middle_east_and_istanbul,

  COUNT
  (
    DISTINCT IF
    (
      datacenter_id = 5415960973531970909 OR # latitude.saopaulo
      datacenter_id = 5507732127557945653 OR # google.saopaulo.1
      datacenter_id = 5507728829023061020 OR # google.saopaulo.2
      datacenter_id = 5507729928534689231.   # google.saopaulo.3
      ,
      session_id, 
      NULL
    )
  ) AS south_america,

  COUNT
  (
    DISTINCT IF
    (
      # virginia
      datacenter_id = -5214568859276043778 OR 
      datacenter_id = -2346230985471481226 OR
      datacenter_id = 4283406570687602836  OR
      datacenter_id = -6972449031730453238 OR 
      datacenter_id = -8671255208384590925 OR
      datacenter_id = 2441965983644586686  OR # google.virginia.1
      datacenter_id = 2441964884132958475  OR # google.virginia.2
      datacenter_id = 2441963784621330264  OR # google.virginia.3

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
      ,
      session_id, 
      NULL
    )
  ) AS north_america,

  COUNT
  (
    DISTINCT IF
    (
      # frankfurt
      datacenter_id = -1955387185768469208 OR 
      datacenter_id = -5522283100318941376 OR 
      datacenter_id = 7432198028711771166  OR 
      datacenter_id = 3321765873280093717  OR 
      datacenter_id = 3830768155627315109  OR 
      datacenter_id = -4297481183583574057 OR
      datacenter_id = -9016912914531346114 OR # google.frankfurt.1
      datacenter_id = -9016914014042974325 OR # google.frankfurt.2
      datacenter_id = -9016915113554602536    # google.frankfurt.3
      ,
      session_id, 
      NULL
    )
  ) AS europe,

FROM
  `analytics.session_summary`
WHERE
  (timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 90 DAY))
GROUP BY
  week
ORDER BY
  week
