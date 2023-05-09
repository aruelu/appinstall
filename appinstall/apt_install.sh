#!/bin/bash
cd $1
GETDISPLAY=$2

TMPFILE="/tmp/appinstalli-"$$".tmp"
LOGFILE="/tmp/appinstall-"$$".log"
CONFFILE="./apt.conf"

zenity --list --width=600 --height=400 --print-column=4 --column=ID --column=プログラム名 --column=説明 --column=パッケージ名 --display=$GETDISPLAY `cat $CONFFILE`  | sed -e "s/,/ /g" > $TMPFILE

TMPLIST=`cat $TMPFILE`
if [ "$TMPLIST" = "" ]
then
    zenity --error --display=$GETDISPLAY --text=ソフトが選択されていません
else
    echo "パッケージ名:" > $LOGFILE
    cat $TMPFILE >> $LOGFILE
    echo "" >> $LOGFILE
    echo "処理結果:" >> $LOGFILE
    zenity --info --title="処理中" --display=$GETDISPLAY --text="このウィンドウが自動で閉じるまで待って下さい" &
    GETPID=`echo $!`
    apt install -y `cat $TMPFILE` &>> $LOGFILE 
    kill $GETPID
    zenity --text-info --title=結果 --width=600  --height=400 --display=$GETDISPLAY --filename=$LOGFILE
fi
