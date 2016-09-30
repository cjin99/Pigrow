#!/bin/bash

# This script downloads files from the pi and sets the most recent as 
# your desktop background image, it is designed to be run via cron. 
#   $crontab -e 
#           */5 * * * * sudo -u magimo /home/USER/camcaps_collector/down_and_update.sh
# 
# user changeable variables
local_dir=/home/magimo/camcaps_collector/caps/
remote_add=pi@192.168.1.12

echo ----
echo Scripted downloader and background up-dater
echo --------

#lists the most recent file in directory before download
echo current most recent...
echo $(ls $local_dir | sort -V | tail -n 1)
echo ---------
#downloads files
rsync --ignore-existing -ratlz --rsh="/usr/bin/sshpass -p raspberry ssh -o StrictHostKeyChecking=no -l $remote_add" $remote_add:/home/pi/cam_caps/text_*.jpg $local_dir

#lists the most recent file after download
echo ----------
echo most recent...
lastfile=$(ls $local_dir | sort -V | tail -n 1)
echo $lastfile

echo ------------
echo updaiting background
# this bit allows it to work from cron
PID=$(pgrep gnome-session)
export DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$PID/environ|cut -d= -f2-)
# set's the background in gnome, unity and derivitives 
gsettings set org.gnome.desktop.background picture-uri file://$local_dir$lastfile