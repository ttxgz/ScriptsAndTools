#!/bin/bash

ROOT=`pwd` || exit 1

MEDIA_PATH="/home/ubuntu/test_media"

############### prod
#RTMP_PUBLISH_PATH="rtmp://rtmp-phx-1.millicast.com:1935/v2/pub"
#RTMP_STREAM="test_zita?token=3f1f19f7a622c4867c87b30711d57faa83cd9b4efe09f32b1be116e13decf49f"

#RTMP_PUBLISH_PATH="rtmp://rtmp-fra-1.millicast.com:1935/v2/pub"
#RTMP_STREAM="zita_pub_fra?token=6d979bb8a7e6a332301a94c58385708c41d266d2c32b147bda7e4785974c1b4c"

############### rp2
RTMP_PUBLISH_PATH="rtmp://rtmp-syd-1-dev.millicast.com:1935/v2/pub"
RTMP_STREAM="test_zita_2?token=727ac3bfae2bb675f857cdd679278790f3fa076c03bcc0bd878ecd97a66138e6"
#RTMP_STREAM=".*?token=727ac3bfae2bb675f857cdd679278790f3fa076c03bcc0bd878ecd97a66138e6"

############### staging
#RTMP_PUBLISH_PATH="rtmp://rtmp-phx-1-staging.millicast.com:1935/v2/pub"
#RTMP_STREAM="zita_release_test_publish?token=7da796d9bf46a17a1ce8643518fa4f2b5c58ef751a2f504f1d2c692706b04238"

#RTMP_PUBLISH_PATH="rtmp://rtmp-blr-1-staging.millicast.com:1935/v2/pub"
#RTMP_STREAM="zita_pub_blr?token=23e0a9f5191b4a815d20a843c66f8437e2dd761dbc4ac04c772b4144a88063a7"

############### local test
#RTMP_PUBLISH_PATH="rtmp://10.204.64.244:1935/v2/pub"
#RTMP_PUBLISH_PATH="rtmp://10.204.65.249:1935/v2/pub"
#RTMP_STREAM="test_zita?token=basic"
# RTMP_STREAM="test_zita?token=clipAndRecord"
#RTMP_PARAMS=""
# RTMP_PARAMS="&record=1"


RTMP_URL="${RTMP_PUBLISH_PATH}/${RTMP_STREAM}"

MUTI_TRACK_FILE="bigBunnyMultitrack_5994_with240p.mp4"
FILE_0="BigBuckBunny1080p30s_noBframe.mp4"
FILE_1="TearsOfSteel_720p_h265.mkv"
FILE_2="BigBuckBunny1080p30s.mp4"

FILE=$MUTI_TRACK_FILE


MEDIA_FILE="$MEDIA_PATH/$FILE"
#MEDIA_FILE1="$MEDIA_PATH/$FILE_1"
#MEDIA_FILE2="$MEDIA_PATH/$FILE_2"
#MEDIA_FILE3="$MEDIA_PATH/$FILE_1"
#MEDIA_FILE4="$MEDIA_PATH/$FILE_2"

#V_CODEC="copy"
#A_CODEC="copy"

V_CODEC="libx264 -preset veryfast -g 30 -r 30 -bf 0"
A_CODEC="aac -ab 96000 -ar 44100 -ac 2"

#V_CODEC="libx264 -b:v 1800k -maxrate 2500k -minrate 800k -bufsize 1000k \
#  -preset veryfast -tune zerolatency -x264opts /"nal-hrd=none:bframes=0/""

echo ${RTMP_URL}


##################### multi video track ##############################################################
# rtmp multi
#ffmpeg -nostdin -fflags +genpts -re  \
#        -stream_loop -1 -i $MEDIA_FILE1 \
#        -stream_loop -1 -i $MEDIA_FILE2 \
#        -stream_loop -1 -i $MEDIA_FILE4 \
#        -stream_loop -1 -i $MEDIA_FILE3 \
#    -map 0:v -map 0:a -c:v $V_CODEC -c:a $A_CODEC -f flv  "${RTMP_URL}&simulcastId&sourceId=0" \
#    -map 1:v -map 1:a -c:v $V_CODEC -an -f flv  "${RTMP_URL}&sourceId=3&simulcastId&videoOnly" \
#    -map 2:v -map 2:a -c:v $V_CODEC -c:a $A_CODEC -f flv  "${RTMP_URL}&sourceId=2&simulcastId=zita_release_test_publish_source_2" \
#    -map 3:v -map 3:a -c:v $V_CODEC -an -f flv  "${RTMP_URL}&sourceId=1&simulcastId=zita_release_test_publish_source_2&videoOnly"

echo "
ffmpeg \
-nostdin -fflags +genpts -re -stream_loop -1 -i $MEDIA_FILE \
-map 0:v:0 -map 0:a:0 -c:a copy -c:v copy -f flv "${RTMP_URL}&sourceId=1&simulcastId&videoTargetBitrate=4000" \
-map 0:v:1 -c:v copy -f flv "${RTMP_URL}&sourceId=2&simulcastId&videoOnly&videoTargetBitrate=1536" \
-map 0:v:2 -c:v copy -f flv "${RTMP_URL}&sourceId=3&simulcastId&videoOnly&videoTargetBitrate=540" \
-map 0:v:3 -c:v copy -f flv "${RTMP_URL}&sourceId=4&simulcastId&videoOnly&videoTargetBitrate=250" \
-map 0:v:4 -c:v copy -f flv "${RTMP_URL}&sourceId=5&simulcastId&videoOnly&videoTargetBitrate=200"
"


ffmpeg \
-nostdin -fflags +genpts -re -stream_loop -1 -i $MEDIA_FILE \
-map 0:v:0 -map 0:a:0 -c:a copy -c:v copy -f flv "${RTMP_URL}&sourceId=1&simulcastId&videoTargetBitrate=4000" \
-map 0:v:1 -c:v copy -f flv "${RTMP_URL}&sourceId=2&simulcastId&videoOnly&videoTargetBitrate=1536" \
-map 0:v:2 -c:v copy -f flv "${RTMP_URL}&sourceId=3&simulcastId&videoOnly&videoTargetBitrate=540" \
-map 0:v:3 -c:v copy -f flv "${RTMP_URL}&sourceId=4&simulcastId&videoOnly&videoTargetBitrate=250" \
-map 0:v:4 -c:v copy -f flv "${RTMP_URL}&sourceId=5&simulcastId&videoOnly&videoTargetBitrate=200"


##################### single video track ##############################################################
#ffmpeg \
#  -re -stream_loop -1 -i $MEDIA_FILE \
#  -c:v $V_CODEC\
#  -c:a $A_CODEC \
#  -muxdelay 0 -muxpreload 0 \
#  -f flv \
#  "${RTMP_PUBLISH_PATH}/${RTMP_STREAM}${RTMP_PARAMS}"
