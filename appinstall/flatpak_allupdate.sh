#!/bin/bash

GETDISPLAY=$1

LOGFILE="/tmp/flatpak_allupdate-"$$".log"

(
zenity --info --title="flatpakの全てのソフトを更新中" --display=$GETDISPLAY --text="このウィンドウが自動で閉じるまで待って下さい" &
GETPID=`echo $!`
echo "flatpak update -y" 
echo ""$GETAPPID 
flatpak update -y 
kill $GETPID
) 2>&1 | tee -a $LOGFILE | \
        zenity --text-info --title="「flatpakの全てのソフト更新」の処理結果" \
               --width=600  --height=400 --display=$GETDISPLAY  \
               --auto-scroll --checkbox="処理終了を確認"
