#!/bin/bash
xhost +local:
pkexec bash  `pwd`/appinstall.sh `pwd` $DISPLAY
xhost -
