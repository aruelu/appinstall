#!/bin/bash

GETDISPLAY=$1

TMPFILE="/tmp/flatpak_fc-cache-"$$".tmp"
LOGFILE="/tmp/flatpak_fc-cache-"$$".log"
DIRBIN=$2

echo $GETUSER

zenity --list --width=600 --height=400 --column="ラップスクリプト名" \
        --display=$GETDISPLAY `ls -1 $DIRBIN/* `> $TMPFILE

GETAPP=`cat $TMPFILE`
if [ "$GETAPP" = "" ]
then
    zenity --error --display=$GETDISPLAY --text=選択されていません
else
    echo "プログラム名:" > $LOGFILE
    echo $GETAPP >> $LOGFILE
    echo "" >> $LOGFILE
    zenity --info --title="処理中" --display=$GETDISPLAY --text="このウィンドウが自動で閉じるまで待って下さい" &
    GETPID=`echo $!`
    GETAPPID=`cat $GETAPP | grep "flatpak" | cut -f 3 -d " "`
    flatpak run --command=fc-cache $GETAPPID -f -v &>> $LOGFILE
    kill $GETPID
    zenity --text-info --title=結果 --width=600  --height=400 --display=$GETDISPLAY --filename=$LOGFILE
fi
