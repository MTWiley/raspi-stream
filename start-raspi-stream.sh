#!/bin/sh
#Written by MTWiley
#Uncomment echo lines for debugging purposes
#echo "start-raspi-stream.sh - scipt started at $(date)" >> /root/start-raspi-stream.log

ps -ef | grep raspistill | grep -v grep | awk '{print $2}' | xargs kill -9
#echo "start-raspi-stream.sh - kill existing raspistill processes ran at $(date)" >> /root/start-raspi-stream.log

mkdir -p /tmp/stream
#echo "start-raspi-stream.sh - mkdir -p /tmp/stream ran at $(date)" >> /root/start-raspi-stream.log

nohup raspistill --nopreview -w 640 -h 480 -q 25 -o /tmp/stream/pic.jpg -tl 10 -t 9999999 -th 0:0:0 -rot 270 -hf >/dev/null 2>&1 &
#echo "start-raspi-stream.sh ran  - start capture process at $(date)" >> /root/start-raspi-stream.log

LD_LIBRARY_PATH=/usr/local/lib /usr/local/bin/mjpg_streamer -i "input_file.so -f /tmp/stream -n pic.jpg" -o "output_http.so -w /usr/local/www" >/dev/null 2>&1 &
#echo "start-raspi-stream.sh ran - create environmental variables at $(date)" >> /root/start-raspi-stream.log
