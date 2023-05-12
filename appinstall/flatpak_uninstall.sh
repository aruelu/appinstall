#!/bin/bash

GETDISPLAY=$1

TMPFILE="/tmp/flatpak_uninstall-"$$".tmp"
LOGFILE="/tmp/flatpak_uninstall-"$$".log"
DIRBIN=$2

zenity --list --width=600 --height=400 --column="ラップスクリプト名" \
        --title="flatpakの削除するソフトを選択して下さい" \
        --display=$GETDISPLAY `ls -1 $DIRBIN/* `> $TMPFILE

GETAPP=`cat $TMPFILE`
if [ "$GETAPP" = "" ]
then
    zenity --error --display=$GETDISPLAY --text=選択されていません
else
    zenity --info --title="削除中" --display=$GETDISPLAY --text="このウィンドウが自動で閉じるまで待って下さい" &
    GETPID=`echo $!`
    GETAPPID=`cat $GETAPP | grep "flatpak" | cut -f 3 -d " "`
    echo "flatpak uninstall -y "$GETAPPID > $LOGFILE
    echo "" >> $LOGFILE
    flatpak uninstall -y $GETAPPID >> $LOGFILE
    rm -f $GETAPP
    kill $GETPID
    zenity --text-info --title="「flatpakのソフト削除」の処理結果" --width=600  --height=400 --display=$GETDISPLAY --filename=$LOGFILE
fi
