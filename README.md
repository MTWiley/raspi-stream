# raspi-stream
# written/put together by MTWiley
# This project is intended to setup a raspberry pi & camera module for streaming.
# This was explicity written/documented for the purpose of being used with Neptune Systems Apex Fusion.
# But it can be adapted for use with just about anything.
########################################################################
### How-To Setup Raspberry Pi Camera Stream For Use With Apex Fusion ###
########################################################################
# Start with this basic tutorial on how to setup "MJPG-Streamer on the Raspberry Pi". Stop at the end of step 6. 
# If you follow that tutorial exactly step 7 & 8 will need to be done everytime you restart your Raspberry Pi and every few minutes.
# So I've documented the process to restart raspistill and keep the stream running.
# 1. Login to your Raspbery Pi.
# 2. sudo su
# 3. vi /etc/init.d/raspi-stream

#!/bin/sh
/root/start-raspi-stream.sh

# (Hit esc, then :wq to write the file and close out of the text editor)
# 4. vi /root/start-raspi-stream.sh

#!/bin/sh
# If you're having issues with the script you can uncomment the echo ... lines debugging purposes to see where it's getting hung up.
# You can also remove the ">/dev/null 2>&1 &" from the end the lines to stop the redirection of stderr and stdout which was 
# implemented to prevent filling up the disk with error messages.

#echo "start-raspi-stream.sh - scipt started at $(date)" >> /root/start-raspi-stream.log

ps -ef | grep raspistill | grep -v grep | awk '{print $2}' | xargs kill -9
#echo "start-raspi-stream.sh - kill existing raspistill processes ran at $(date)" >> /root/start-raspi-stream.log

mkdir -p /tmp/stream
#echo "start-raspi-stream.sh - mkdir -p /tmp/stream ran at $(date)" >> /root/start-raspi-stream.log

nohup raspistill --nopreview -w 640 -h 480 -q 25 -o /tmp/stream/pic.jpg -tl 10 -t 9999999 -th 0:0:0 -rot 270 -hf >/dev/null 2>&1 &
#echo "start-raspi-stream.sh ran  - start capture process at $(date)" >> /root/start-raspi-stream.log

LD_LIBRARY_PATH=/usr/local/lib /usr/local/bin/mjpg_streamer -i "input_file.so -f /tmp/stream -n pic.jpg" -o "output_http.so -w /usr/local/www" >/dev/null 2>&1 &
#echo "start-raspi-stream.sh ran - create environmental variables at $(date)" >> /root/start-raspi-stream.log

# (Hit esc, then :wq to write the file and close out of the text editor)
# 5. chmod ugo+x /etc/init.d/raspi-stream
# 6. update-rc.d raspi-stream defaults
# 7. Setup Fusion
#   a. If you haven't already, add the webcam tile to your dashboard.
#   b. Click on the gear for the webcam tile to get to settings.
#   c. Click the plus sign to add the stream
#   d. Name it something useful
#   e. Change the level to view
#   f. Change the type to Image/Motion JPEG
#   g. http://yoururl.net:8080/?action=stream (In order for Apex Fusion to be able to display the stream you'll need to have setup port forwarding, if using the defaults in the tutorial above the port you'll need to forward is port 8080)
