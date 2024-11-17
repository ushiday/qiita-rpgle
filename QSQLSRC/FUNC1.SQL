-- ＵＤＦ（ユーザー定義関数）作成
CREATE OR REPLACE FUNCTION
  USHIDA@Q24.MY_ZEIKOMI2
  (
    IN_KING1 NUMERIC(011 ,00)
  )
  RETURNS NUMERIC(011 ,00)
  LANGUAGE RPGLE
  EXTERNAL NAME 'USHIDA@Q24/Q240201R(MY_ZEIKOMI)'
  PARAMETER STYLE GENERAL
;

-- 実行
SELECT
   KING1
  ,USHIDA@Q24.MY_ZEIKOMI2(KING1) AS KING2
  FROM
  ( SELECT
       1000 AS KING1
      FROM SYSIBM.SYSDUMMY1
  )
;





































































































