#!/bin/bash

cd `dirname $0`
DIRBIN=$HOME/.local/myflatpak
xhost +local:
GETSEL=`zenity --list --title="処理選択" \
        --print-column=1 --column="ID" --column="select" \
        --width=600  --height=400 \
        "01" "aptでインストール" \
        "02" "flatpakでインストール" \
        "03" "flatpakの文字化け改善" \
        "04" "flatpakのソフト起動" \
        "05" "flatpakのソフト更新" \
        "06" "flatpakのソフト削除" `
echo $GETSEL
if [ "$GETSEL" = "01" ]
then
    pkexec bash  `pwd`/appinstall.sh `pwd` $DISPLAY

elif [ "$GETSEL" = "02" ]
then
    pkexec bash  `pwd`/appinstall_flatpak.sh `pwd` $DISPLAY $DIRBIN $USER

elif [ "$GETSEL" = "03" ]
then
    bash  `pwd`/flatpak_fc-cache.sh $DISPLAY $DIRBIN

elif [ "$GETSEL" = "04" ]
then
    bash  `pwd`/run_flatpak.sh $DISPLAY $DIRBIN

elif [ "$GETSEL" = "05" ]
then
    bash  `pwd`/flatpak_update.sh $DISPLAY $DIRBIN

elif [ "$GETSEL" = "06" ]
then
    bash  `pwd`/flatpak_uninstall.sh $DISPLAY $DIRBIN

else
    zenity --error --text="処理が選択されていません"
fi
xhost -
