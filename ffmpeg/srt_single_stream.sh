#!/bin/bash

ROOT=`pwd` || exit 1

MEDIA_PATH="/home/ubuntu/test_media"

############### rp2

############### prod
#SRT_PUBLISH_URL="srt://srt-fra-1.millicast.com:10000"
#SRT_STREAM="zita_pub_fra?t=bZebuKfmozIwGpTFg4VwjEHSZtLDKxR72n5HhZdMG0w"
 


############### staging
# syd-1
#SRT_PUBLISH_URL="srt://srt-syd-1-staging.millicast.com:10000"
#SRT_STREAM="test_zita_srt?t=jOTF0ROM82imBl-VLs_AascFwlp8TQDOl080hbE7onM"

# lon-1
SRT_PUBLISH_URL="srt://srt-lon-1-staging.millicast.com:10000"
SRT_STREAM="test_zita_srt?t=RHT4mu7lPNxRNPIX5kkHtSMAPBycN4AypD5QKx4tLh4"


############### local test
#SRT_PUBLISH_URL="srt://10.204.65.249:10000"
#SRT_STREAM="test_zita?token=basic"
#SRT_STREAM="test_zita?token=clipAndRecord"


SRT_URL="${SRT_PUBLISH_URL}?streamid=${SRT_STREAM}"

MUTI_TRACK_FILE="reference_mbr.mp4"
FILE_0="BigBuckBunny1080p30s_noBframe.mp4"
FILE_1="TearsOfSteel_720p_h265.mkv"
FILE_2="BigBuckBunny1080p30s.mp4"

FILE="BigBuckBunny1080p30s.mp4"

FILE=$MUTI_TRACK_FILE
MEDIA_FILE="${MEDIA_PATH}/${FILE}"

V_CODEC="copy"
#V_CODEC="libx264 -preset veryfast -g 30 -r 30 -bf 0"
#V_CODEC="libx265 -preset veryfast -g 30 -r 30 -bf 0"

A_CODEC="copy"
#A_CODEC="aac -ab 96000 -ar 44100 -ac 2"


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
