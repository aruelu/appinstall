#!/bin/bash

DIRBIN=$HOME/.local/myflatpak

sudo apt update
sudo apt install -y zenity
sudo apt install -y pkexec
sudo apt install -y flatpak
sudo apt install -y gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
if [ ! -d $DIRBIN ]
then
    mkdir $DIRBIN
fi

zenity --info --text="設定を反映するためには再起動が必要です"
