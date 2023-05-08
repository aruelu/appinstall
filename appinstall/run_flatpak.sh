#!/bin/bash

GETDISPLAY=$1

TMPFILE="/tmp/run_flatpak-"$$".tmp"
LOGFILE="/tmp/run_flatpak-"$$".log"
DIRBIN=$2

echo $GETUSER

zenity --list --width=600 --height=400 --column="ラップスクリプト名" \
        --display=$GETDISPLAY `ls -1 $DIRBIN/* `> $TMPFILE

GETAPP=`cat $TMPFILE`
if [ "$GETAPP" = "" ]
then
    zenity --error --display=$GETDISPLAY --text=選択されていません
else
    GETAPPID=`cat $GETAPP | grep "flatpak" | cut -f 3 -d " "`
    echo "flatpak run "$GETAPPID > $LOGFILE
    flatpak run $GETAPPID &
fi
