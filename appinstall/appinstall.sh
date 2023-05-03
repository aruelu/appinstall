#/bin/bash

zenity --list --width=600 --height=400 --print-column=4 --column=ID --column=プログラム名 --column=説明 --column=パッケージ名 `cat ./appinstall.conf`  | sed -e "s/,/ /g" > ./tmp.list

TEMPLIST=`cat ./tmp.list`
if [ "$TEMPLIST" = "" ]
then
    zenity --error --text=ソフトが選択されていません
else
    echo "パッケージ名:" > /tmp/appinstall.log
    cat ./tmp.list >> /tmp/appinstall.log
    echo "処理結果:" >> /tmp/appinstall.log
    xhost +local:
    pkexec apt install -y `cat ./tmp.list` 2>&1 | tee -a /tmp/appinstall.log | zenity --progress --auto-close --title=キャンセルは押さないで
    xhost -
    zenity --text-info --title=結果 --width=600  --height=400 --filename=/tmp/appinstall.log
fi
rm -f ./tmp.list ./install.log
