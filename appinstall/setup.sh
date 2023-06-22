#!/bin/bash

DIRBIN=$HOME/.local/myflatpak

if type apt &> /dev/null
then
    sudo apt update
    package_command="apt install -y"

elif type yum &> /dev/null
then
    package_command="yum install -y"

#elif type pacman &> /dev/null
#then
#    sudo pacman -Syy
#    package_command="pacman -S"
#
#elif type zypper &> /dev/null
#then
#    sudo zypper refresh
#    package_command="zypper --non-interactive in"
#
else
    echo "サポートされているパッケージマネージャが無いため終了します！"
    exit 1

fi

echo "パッケージマネージャのコマンド：""$package_command"
sudo $package_command zenity
sudo $package_command pkexec
sudo $package_command flatpak
sudo $package_command gnome-software-plugin-flatpak

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
if [ ! -d $DIRBIN ]
then
    mkdir $DIRBIN
fi

zenity --info --text="設定を反映するためには再起動が必要です"
