#!/bin/bash

GETDISPLAY=$1

TMPFILE="/tmp/flatpak_fc-cache-"$$".tmp"
LOGFILE="/tmp/flatpak_fc-cache-"$$".log"
DIRBIN=$2

echo $GETUSER

zenity --list --width=600 --height=400 --column="ラップスクリプト名" \
        --title="flatpakの文字化け改善をしたいソフトを選択して下さい" \
        --display=$GETDISPLAY `ls -1 $DIRBIN/* `> $TMPFILE

GETAPP=`cat $TMPFILE`
if [ "$GETAPP" = "" ]
then
    zenity --error --display=$GETDISPLAY --text=選択されていません
else
    (
    echo "プログラム名:" 
    echo $GETAPP 
    echo "" 
    zenity --info --title="処理中" --display=$GETDISPLAY --text="このウィンドウが自動で閉じるまで待って下さい" &
    GETPID=`echo $!`
    GETAPPID=`cat $GETAPP | grep "flatpak" | cut -f 3 -d " "`
    flatpak run --command=fc-cache $GETAPPID -f -v 
    kill $GETPID
    ) 2>&1 | tee -a $LOGFILE | \
             zenity --text-info --title="「flatpakの文字化け改善」の処理結果" \
                    --width=600  --height=400 --display=$GETDISPLAY  \
                    --auto-scroll --checkbox="処理終了を確認"
fi
