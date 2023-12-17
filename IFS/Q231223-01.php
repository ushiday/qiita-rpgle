<?php

$db = db2_connect('*LOCAL' ,'hogeuser' ,'fugapwd');

if(!$db){
    $message = 'Error->DB2 Connect:<'. date('Y/m/d H:i:s (T)') .'>'
                .PHP_EOL .db2_conn_errormsg() . PHP_EOL;
    echo $message;
    exit(1);
}

//スキーマのセット
$sql = 'set schema "USHIDA@Q23"' ;
$stmt = db2_exec($db,$sql);
if(!$stmt){
    $message = 'スキーマセットに失敗'
                .PHP_EOL .db2_stmt_errormsg() . PHP_EOL;
    echo $message;
    exit(2);
}

//左から「バックスラッシュ、円マーク、ドル記号」
$val ='\¥$';

//SQL文
$sql=<<<EOT
INSERT INTO Q231223F
(
  SELECT
    '$val' AS CHAR_5026
   ,'$val' AS CHAR_5035
   ,'$val' AS CHAR_1399
  FROM SYSIBM.SYSDUMMY1
)
EOT;


// SQLプリペア
$stmt = db2_prepare($db,$sql);
if($stmt === false){
    echo 'ERR(01)Prepareエラー' , '<br>';
    exit(3);
}
// SQLの実行
$result = db2_execute($stmt) ;

if(!$result){
    $message = 'SQL失敗'
                .PHP_EOL .$sql . PHP_EOL
                .PHP_EOL .db2_stmt_errormsg() . PHP_EOL;
    echo $message;
    exit(4);
}

$message = 'SQL成功'
            .PHP_EOL .$sql . PHP_EOL;
echo $message;

