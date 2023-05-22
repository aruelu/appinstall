#!/bin/bash
cd $1
GETDISPLAY=$2


GETSTRFILE="/tmp/search-install-str_"$$".tmp"
TMPFILE="/tmp/search-install-tmp_"$$".tmp"
APPLIST="/tmp/search-install-applist_"$$".list"
SELAPP="/tmp/search-install-selapp_"$$".list"
LOGFILE="/tmp/serch-install_"$$".log"

DIRBIN=$3

GETUSER=$4
echo $GETDISPLAY

. ./appinstall_function

zenity --entry --width=300 --height=100 \
        --title="flatpakで検索するソフトを入力して下さい" \
        --display=$GETDISPLAY  > $GETSTRFILE

GETSTR=`cat $GETSTRFILE`
echo "GETSTR="$GETSTR
if [ "$GETSTR" = "" ]
then
    zenity --error --display=$GETDISPLAY --text="入力されていません"
    exit 1
fi

flatpak search "$GETSTR" | grep "$GETSTR" | \
    awk -F "\t" '{ print $1"\t" $6"," $3 }' | \
    sort | uniq  > $TMPFILE

#if [ `cat $TMPFILE | grep "Plugin" | wc -l` != 0  ]
#then
#    zenity --question --display=$GETDISPLAY --text="Pluginも含めますか？" --title="確認"
#    if [ $? = 0 ]
#    then
#        cat $TMPFILE | awk -F "\t" '{ print $1"\n"$2 }' > $APPLIST
#    else
#        cat $TMPFILE | grep -v "Plugin" | awk -F "\t" '{ print $1"\n"$2 }'> $APPLIST
#    fi
#else
#    cat $TMPFILE | awk -F "\t" '{ print $1"\n"$2 }' > $APPLIST
#
#fi
cat $TMPFILE | grep -v "Plugin" | awk -F "\t" '{ print $1"\n"$2 }'> $APPLIST

if [ `cat $APPLIST | wc -l ` = 0 ]
then
    zenity --error --display=$GETDISPLAY --title="実行エラー" --text="ソフトがありません"
    exit 2
else
    cat $APPLIST | zenity --list --display=$GETDISPLAY \
                          --title="インストールするソフトを選択して下さい" \
                          --width=600 --height=400 \
                          --column="ソフト名" --column="appID" --print-column=ALL > $SELAPP
fi

if [ `cat $SELAPP |  wc -l` = 0 ]
then
    zenity --error --display=$GETDISPLAY --title="実行エラー" --text="ソフトが選択されていません"
    exit 3
else
    APPNAME=`cat $SELAPP | cut -f 1 -d "|"`
    GETREMOTES=`cat $SELAPP | cut -f 2 -d "|" | cut -f 1 -d ","`
    GETAPPID=`cat $SELAPP | cut -f 2 -d "|" | cut -f 2 -d ","`

    cat $SELAPP
    echo $APPNAME
    echo $GETREMOTES
    echo $GETAPPID
    echo $GETDISPLAY


    zenity --info --title="処理中" --display="$GETDISPLAY" \
           --text="このウィンドウが自動で閉じるまで待って下さい" &
    GETPID=`echo $!`
    flatpakinstall "$LOGFILE" "$DIRBIN" "$APPNAME" "$GETREMOTES" "$GETAPPID" "$GETDISPLAY"
    kill $GETPID
    zenity --text-info --title="「flatpakで探してインストール」の処理結果" \
            --width=600  --height=400 --display=$GETDISPLAY --filename=$LOGFILE


fi
