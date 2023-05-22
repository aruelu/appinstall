#!/bin/bash
cd $1
GETDISPLAY=$2

TMPFILE="/tmp/appinstall_flatpak-"$$".tmp"
LOGFILE="/tmp/appinstall_flatpak-"$$".log"
CONFFILE="./flatpak.conf"
DIRBIN=$3

GETUSER=$4
echo $GETDISPLAY

. ./appinstall_function

zenity --list --width=600 --height=400 --column=ID \
        --column=プログラム名 --column=説明 --column=パッケージ名 \
        --title="flatpakでインストールするソフトを選択して下さい" \
        --display=$GETDISPLAY `cat $CONFFILE` > $TMPFILE

RETID=`cat $TMPFILE`
echo $RETID
if [ "$RETID" = "" ]
then
    zenity --error --display=$GETDISPLAY --text=ソフトが選択されていません
else
    TMPLIST=`cat $CONFFILE | grep ^$RETID`
    echo $TMPLIST
    APPNAME=`echo $TMPLIST | cut -f 2 -d " "`
    GETREMOTES=`echo $TMPLIST | cut -f 4 -d " " | cut -f 1 -d ","`
    GETAPPID=`echo $TMPLIST | cut -f 4 -d " " | cut -f 2 -d ","`
    zenity --info --title="処理中" --display=$GETDISPLAY --text="このウィンドウが自動で閉じるまで待って下さい" &
    GETPID=`echo $!`
    flatpakinstall $LOGFILE $DIRBIN $APPNAME $GETREMOTES $GETAPPID $GETDISPLAY
    kill $GETPID
    zenity --text-info --title="「flatpakでインストール」の処理結果" --width=600  --height=400 --display=$GETDISPLAY --filename=$LOGFILE
fi
