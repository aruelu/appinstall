#!/bin/bash

cd `dirname $0`
xhost +local:
pkexec bash  `pwd`/appinstall.sh `pwd` $DISPLAY
xhost -
