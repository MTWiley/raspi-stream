#!/bin/sh
# If you're having issues with the script you can uncomment the echo ... lines debugging purposes to see where it's getting hung up.`
# You can also remove the ">/dev/null 2>&1 &" from the end the lines to stop the redirection of stderr and stdout which was
# implemented to prevent filling up the disk with error messages.

# echo "start-raspi-stream.sh - scipt started at $(date)" >> /root/start-raspi-stream.log

ps -ef | grep raspistill | grep -v grep | awk '{print }' | xargs kill -9
# echo "kill existing raspistill processes ran at $(date)" >> /root/start-raspi-stream.log

mkdir -p /tmp/stream
# echo "mkdir -p /tmp/stream ran at $(date)" >> /root/start-raspi-stream.log

# Explanation of basic user adjustable camera parameters:
# -rot X = rotate image X degrees
# -w # = image width X pixels
# -h # = image height X pixels
# See https://www.raspberrypi.org/documentation/raspbian/applications/camera.md for more information
nohup raspistill --nopreview -w 640 -h 480 -q 25 -o /tmp/stream/pic.jpg -tl 10 -t 9999999 -th 0:0:0 -rot 270 -hf >/dev/null 2>&1 &
# echo "start-raspi-stream.sh ran  - start capture process at $(date)" >> /root/start-raspi-stream.log


LD_LIBRARY_PATH=/usr/local/lib /usr/local/bin/mjpg_streamer -i "input_file.so -f /tmp/stream -n pic.jpg" -o "output_http.so -w /usr/local/www" >/dev/null 2>&1 &
# echo "start-raspi-stream.sh ran - created LD_LIBRARY_PATH variables at $(date)" >> /root/start-raspi-stream.log

# echo "end of start-raspi-stream.sh"  >> /root/start-raspi-stream.log
