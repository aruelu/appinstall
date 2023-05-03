#/bin/bash

zenity --list --width=600 --height=400 --print-column=4 --column=ID --column=プログラム名 --column=説明 --column=パッケージ名 `cat ./appinstall.conf`  | sed -e "s/,/ /g" > ./tmp.list

TEMPLIST=`cat ./tmp.list`
if [ "$TEMPLIST" = "" ]
then
    zenity --error --text=ソフトが選択されていません
else
    GETPASS=`zenity --password`
    if [ "$GETPASS" = "" ]
    then
        zenity --error --text=パスワードが入力されていません
    else
        echo "パッケージ名:" > ./install.log
        cat ./tmp.list >> ./install.log
        echo "" >> ./install.log
        echo "処理結果:" >> ./install.log
        echo $GETPASS | sudo -S apt install -y `cat ./tmp.list` 2>&1 | tee -a ./install.log | zenity --progress --width=600 --height=200 --title=OKが押せるまで待って下さい（キャンセルは押さないで）
        zenity --text-info --title=結果 --width=600  --height=400 --filename=./install.log
    fi
fi
rm -f ./tmp.list ./install.log
