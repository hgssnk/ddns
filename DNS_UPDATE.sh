#!/bin/bash

# 入力箇所
USERID="ここにお名前.comのID"
PASSWORD="ここにお名前.comのパスワード"
HOSTNAME="ここにホスト名"
DOMNAME="ここにドメイン名"
LOG_FILE="ログを吐き出すディレクトリを絶対パスで指定"
HOST="ここに「ホスト名.ドメイン名」を入力"

# 定数
UPDATE_FLG="0"
DATE=$(date '+%Y-%m-%d %H:%M:%S')
MESSAGE="IPは更新の必要がありませんでした。"

# Global IPアドレス取得
gip=$(curl inet-ip.info)
domip=$(dig $HOST +short)

# IPアドレス更新
if [ "$gip" != "$domip" ]; then
  {
    echo "LOGIN"
    echo "USERID:$USERID"
    echo "PASSWORD:$PASSWORD"
    echo "."
    echo "MODIP"
    echo "HOSTNAME:$HOSTNAME"
    echo "DOMNAME:$DOMNAME"
    echo "IPV4:$gip"
    echo "."
    echo "LOGOUT"
    echo "."
  } > DDNS_INPUT_FILE.txt
  openssl s_client -connect ddnsclient.onamae.com:65010 -quiet < DDNS_INPUT_FILE.txt
  $UPDATE_FLG="1"
else
  echo "$MESSAGE"
fi

# ログ出力
if [ $UPDATE_FLG = 1 ]; then
  {
    echo "DATE    $DATE"
    echo "BEFORE  $domip"
    echo "AFTER   $gip"
    echo ""
  } >> ${LOG_FILE}/DNS_UPDATE.log
fi

exit 0
