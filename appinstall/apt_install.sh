#!/bin/bash
cd $1
GETDISPLAY=$2

TMPFILE="/tmp/appinstall-"$$".tmp"
LOGFILE="/tmp/appinstall-"$$".log"
CONFFILE="./apt.conf"

zenity --list --title="aptでインストールするソフトを選択して下さい" --width=600 --height=400 --print-column=4 --column=ID --column=プログラム名 --column=説明 --column=パッケージ名 --display=$GETDISPLAY `cat $CONFFILE`  | sed -e "s/,/ /g" > $TMPFILE

TMPLIST=`cat $TMPFILE`
if [ "$TMPLIST" = "" ]
then
    zenity --error --display=$GETDISPLAY --text=ソフトが選択されていません
else
    (
    echo "パッケージ名:" 
    cat $TMPFILE 
    echo "" 
    echo "処理結果:" 
    #zenity --info --title="処理中" --display=$GETDISPLAY --text="このウィンドウが自動で閉じるまで待って下さい" &
    #GETPID=`echo $!`
    apt install -y `cat $TMPFILE` 
    #kill $GETPID
    ) | tee -a $LOGFILE | \
    zenity --text-info --title="「aptでインストール」の処理結果" \
           --width=600  --height=400 --display=$GETDISPLAY  \
           --auto-scroll --checkbox="処理終了を確認"
fi
