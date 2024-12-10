**FREE
//   H**********************************************************************
//   H*                                                                    *
//   H*   システム名      :ＲＰＧ教育                                *
//   H*   サブシステム名  :教育プログラム　　　　　　　　　　　      *
//   H*   プログラム名    :％ＰＲＯＣのＯＮ−ＥＸＩＴ内での使用      *
//   H*   プログラムＩＤ  : Q242101R                                   *
//   H*   会　社　名　　  :株式会社中部システム                      *
//   H*                                                                    *
//   H*     作　成　者    :㈱中部システム Y.USHIDA                   *
//   H*     作　成　日    : 2024/12/02                                 *
//   H*     管　理　番　号: ____________                               *
//   H*                                                                    *
//   H*     変　更　者    :　　　　　　　　　　　　　　　　　　      *
//   H*     変　更　日    : ____/__/__                                 *
//   H*     管　理　番　号:                                            *
//   H*                                                                    *
//   H*  プログラム特記事項                                              *
//   H* 　　　　　　　　　　　＿　　　　　　　　　　　　　　　　　　   *
//   H* 　　　　　　　　　　　＿　　　　　　　　　　　　　　　　　　   *
//   H*                                                                    *
//   H*-*******************************************************************
//   H*-*Ｈ仕様書                                                      **
//   H*-*******************************************************************
CTL-OPT
       DFTACTGRP(*NO) ACTGRP(*NEW)
       DATEDIT(*YMD)
       DECEDIT('0.')
       EXPROPTS(*RESDECPOS)
       CURSYM('¥')
       COPYRIGHT('...')
;
//   D*-********************************************************************
//   D*-* ＳＤＳ宣言                                                    **
//   D*-********************************************************************
//   https://www.ibm.com/docs/ja/i/7.5?topic=exceptionerrors-program-status-data-structure
DCL-DS *N PSDS;
       S#PGM               *PROC                         ;                    //プログラム名
       S#STS               *STATUS                       ;                    //状況コード
       S#ROUTINE           *ROUTINE                      ;                    //ルーチン名
       S#JOB               CHAR(10)     POS(244)         ;                    //ジョブ名
       S#USER              CHAR(10)     POS(254)         ;                    //ユーザー名
       S#JNBR              ZONED(6:0)   POS(264)         ;                    //ジョブ№
END-DS;
//   D*-********************************************************************
//   D*-* 変数等宣言                                                    **
//   D*-********************************************************************
DCL-S  W#RTN         CHAR(040      )          ;  //結果
//   C*-********************************************************************
//   C*-* メインルーチン                                                **
//   C*-********************************************************************

W#RTN       = SUBPROC1(99999          )       ;
DSPLY         W#RTN                           ;


W#RTN       = SUBPROC1(90000          )       ;
DSPLY         W#RTN                           ;


*INLR       = *ON                             ;
RETURN                                        ;

//   P*-********************************************************************
//   P*-* サブプロシージャ（１）                                        **
//   P*-********************************************************************
DCL-PROC SUBPROC1                               ;
//インターフェース
  DCL-PI *N   CHAR(001      )                   ;  //Ｓ＝成功、Ｅ＝失敗
     IN_CODE          PACKED(005 :000) VALUE    ;  //コード
  END-PI;
  //   F*-*******************************************************************
  //   F*-*ファイル宣言                                                  **
  //   F*-*******************************************************************
  DCL-F    ITEM          KEYED    USAGE(*UPDATE : *OUTPUT     )                ;
    DCL-DS   R#ITEMR                LIKEREC(ITEMR       :*ALL         )          ;
    DCL-DS   K#ITEM                 LIKEREC(ITEMR       :*KEY         )          ;
  //   D*-********************************************************************
  //   D*-* 変数等宣言                                                    **
  //   D*-********************************************************************
  DCL-S  W#MSG         CHAR(040      )          ;  //メッセージ
  DCL-S  W#ZERO        PACKED(003 :000   )      ;
  DCL-S  W#NOMON       IND                      ;  //＊ＯＮ＝監視なしの終了
  DCL-S  W#PGM1        CHAR(010      )          ;  //プログラム名
  DCL-S  W#PROC1       CHAR(040      )          ;  //プロシージャ名
  DCL-S  W#PROC2       CHAR(040      )          ;  //プロシージャ名
  DCL-S  W#PROC3       CHAR(040      )          ;  //プロシージャ名

//プログラム名取得
  W#PGM1      = S#PGM                           ;

//サブプロシージャ名取得
  W#PROC1     = %PROC()                         ;

//サブロジック
  K#ITEM.CODE = IN_CODE                         ;

  MONITOR                                       ;
    CHAIN %KDS(K#ITEM    :01 ) ITEMR     R#ITEMR  ;
    IF %FOUND                                     ;
      WRITE   ITEMR     R#ITEMR                     ;
    ENDIF                                         ;
  ON-ERROR  *ALL                                ;
    W#MSG   = '[ERROR:*ALL]'
            + %CHAR(%STATUS     )
            + '*ALL監視エラー'                  ;
    DSPLY     W#MSG                               ;
    RETURN    'E'                                 ;
  ENDMON                                        ;


  W#ZERO      = *ZERO                           ;
  W#ZERO      = 100     / W#ZERO                ;

  RETURN    'S'                                 ;

//必ずサブプロシージャで通過する終了処理
  ON-EXIT   W#NOMON                             ;

  //ＯＮ−ＥＸＩＴを実装実行しているサブプロシージャ名
  W#PROC2     = %PROC(*ONEXIT        )          ;

  //ＯＮ−ＥＸＩＴの実装呼び出し元サブプロシージャ名（※このソース）
  W#PROC3     = %PROC(*OWNER         )          ;

    W#MSG   = '[S#PGM][S#ROUTINE]'
            + %TRIM(S#PGM  )
            + ' ' + S#ROUTINE                     ;
    DSPLY     W#MSG                               ;

    W#MSG   = '[W#PROC1]'
            + %TRIM(W#PGM1  )
            + ' ' + W#PROC1                       ;
    DSPLY     W#MSG                               ;

    W#MSG   = '[W#PROC2]'
            + %TRIM(W#PGM1  )
            + ' ' + W#PROC2                       ;
    DSPLY     W#MSG                               ;

    W#MSG   = '[W#PROC3]'
            + %TRIM(W#PGM1  )
            + ' ' + W#PROC3                       ;
    DSPLY     W#MSG                               ;

    IF %FOUND(ITEM        )                       ;
      UNLOCK ITEM                                   ;
      W#MSG   = '[UNLOCK]'
              + 'レコードロック解放'              ;
      DSPLY     W#MSG                               ;
    ENDIF                                         ;
    W#MSG   = '[EXIT]'
            + '全ての処理が通過する'
            + %CHAR(W#NOMON    )                  ;
    DSPLY     W#MSG                               ;

//監視外の例外が発生している場合
    IF W#NOMON                                    ;
      //ログなど...
      RETURN    'E'                                 ;
    ENDIF                                         ;

END-PROC;
