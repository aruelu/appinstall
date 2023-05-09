#!/bin/bash
cd $1
GETDISPLAY=$2

TMPFILE="/tmp/appinstall_flatpak-"$$".tmp"
LOGFILE="/tmp/appinstall_flatpak-"$$".log"
CONFFILE="./flatpak.conf"
DIRBIN=$3

GETUSER=$4
echo $GETUSER

zenity --list --width=600 --height=400 --column=ID \
        --column=プログラム名 --column=説明 --column=パッケージ名 \
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
    echo "ソフト名:" > $LOGFILE
    echo $APPNAME >> $LOGFILE
    echo "" >> $LOGFILE
    echo "remotes,Application ID:" >> $LOGFILE
    echo $GETREMOTES","$GETAPPID >> $LOGFILE
    echo "" >> $LOGFILE
    echo "処理結果:" >> $LOGFILE
    zenity --info --title="処理中" --display=$GETDISPLAY --text="このウィンドウが自動で閉じるまで待って下さい" &
    GETPID=`echo $!`
    flatpak install -y $GETREMOTES $GETAPPID &>> $LOGFILE 
    echo "" >> $LOGFILE
    echo "############################################################################" >> $LOGFILE
    echo "flatpak run --command=fc-cache "$GETAPPID" -f -v" >> $LOGFILE
    flatpak run --command=fc-cache $GETAPPID -f -v >> $LOGFILE
    if [ $? == 0 ]
    then
        RAPNAME=$DIRBIN"/"`echo $APPNAME | tr '[:upper:]' '[:lower:]'`
        echo "#!/bin/bash" > $RAPNAME
        echo "flatpak run "$GETAPPID >> $RAPNAME
        chown $GETUSER:$GETUSER $RAPNAME
        chmod +x $RAPNAME
        zenity --info --title="実行方法" --display=$GETDISPLAY --text=`echo $RAPNAME`"で実行できます" &
    fi
    kill $GETPID
    zenity --text-info --title=結果 --width=600  --height=400 --display=$GETDISPLAY --filename=$LOGFILE
fi
