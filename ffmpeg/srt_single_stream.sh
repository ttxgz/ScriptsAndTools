#!/bin/bash

ROOT=`pwd` || exit 1

MEDIA_PATH="/home/ubuntu/test_media"

############### rp2

############### prod
#SRT_PUBLISH_URL="srt://srt-fra-1.millicast.com:10000"
#SRT_STREAM="zita_pub_fra?t=bZebuKfmozIwGpTFg4VwjEHSZtLDKxR72n5HhZdMG0w"
 


############### staging
SRT_PUBLISH_URL="srt://srt-syd-1-staging.millicast.com:10000"
SRT_STREAM="test_zita?t=jOTF0ROM82imBl-VLs_AascFwlp8TQDOl080hbE7onM"


############### local test
#SRT_PUBLISH_URL="srt://10.204.65.249:10000"
#SRT_STREAM="test_zita?token=basic"
#SRT_STREAM="test_zita?token=clipAndRecord"


SRT_URL="${SRT_PUBLISH_URL}?streamid=${SRT_STREAM}"

FILE="BigBuckBunny1080p30s.mp4"

MEDIA_FILE="${MEDIA_PATH}/${FILE}"

#V_CODEC="copy"
#A_CODEC="copy"

V_CODEC="libx264 -preset veryfast -g 30 -r 30 -bf 0"
A_CODEC="aac -ab 96000 -ar 44100 -ac 2"

#V_CODEC="libx264 -b:v 1800k -maxrate 2500k -minrate 800k -bufsize 1000k \
#  -preset veryfast -tune zerolatency -x264opts /"nal-hrd=none:bframes=0/""

echo ${SRT_URL}

#create sameple test stream
#resolution=1920x1080
#fps=30
#bitrate="400000"
#ffmpeg -re -stream_loop -1 -f lavfi -i "testsrc=size=${resolution}:rate=${fps}" \
#      -f lavfi -i "sine=frequency=220:beep_factor=4" \
#      -b:v "$bitrate" -profile:v high -pix_fmt yuv420p \
#      -vf "drawtext=fontsize=150:fontcolor=red:x=(w-tw)/4:y=(h-th)/2:text='%{pts\\:hms} %{n}':timecode_rate=${fps}" \
#      -c:v libx264 -bf 0 -g ${fps} -c:a aac \
#      -f mpegts "${SRT_URL}"

ffmpeg -re -stream_loop -1 -i ${MEDIA_FILE} \
      -c:v ${V_CODEC} -c:a ${A_CODEC} \
      -f mpegts "${SRT_URL}"
