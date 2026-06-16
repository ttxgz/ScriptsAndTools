#!/bin/bash

ROOT=`pwd` || exit 1

MEDIA_PATH="/home/ubuntu/test_media"

############### prod
#RTMP_PUBLISH_PATH="rtmp://rtmp-phx-1.millicast.com:1935/v2/pub"
TOKEN="3f1f19f7a622c4867c87b30711d57faa83cd9b4efe09f32b1be116e13decf49f"

#RTMP_PUBLISH_PATH="rtmp://rtmp-fra-1.millicast.com:1935/v2/pub"
TOKEN="6d979bb8a7e6a332301a94c58385708c41d266d2c32b147bda7e4785974c1b4c"

############### rp2
#RTMP_PUBLISH_PATH="rtmp://rtmp-syd-1-dev.millicast.com:1935/v2/pub"
TOKEN="727ac3bfae2bb675f857cdd679278790f3fa076c03bcc0bd878ecd97a66138e6"

############### staging
## syd
#RTMP_PUBLISH_PATH="rtmp://rtmp-syd-1-staging.millicast.com:1935/v2/pub"
#TOKEN="8ce4c5d1138cf368a6065f952ecfc06ac705c25a7c4d00ce974f3485b13ba273"
## lon
RTMP_PUBLISH_PATH="rtmp://rtmp-lon-1-staging.millicast.com:1935/v2/pub"
TOKEN="4474f89aeee53cdc5134f217e64907b523003c1c9c378032a43e502b1e2d2e1e"

############### local test
#RTMP_PUBLISH_PATH="rtmp://10.204.65.249:1935/v2/pub"
#TOKEN="basic"
#TOKEN="clipAndRecord"

# multiple streams
BASE_STREAM_NAME=test_zita

#RTMP_PARAMS=""
#RTMP_PARAMS="&record=1"


#RTMP_URL="${RTMP_PUBLISH_PATH}/${RTMP_STREAM}"

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

#echo "
#ffmpeg \
#-nostdin -fflags +genpts -re -stream_loop -1 -i $MEDIA_FILE \
#-map 0:v:0 -map 0:a:0 -c:a copy -c:v copy -f flv "${RTMP_URL}&sourceId=1&simulcastId&videoTargetBitrate=4000" \
#-map 0:v:1 -c:v copy -f flv "${RTMP_URL}&sourceId=2&simulcastId&videoOnly&videoTargetBitrate=1536" \
#-map 0:v:2 -c:v copy -f flv "${RTMP_URL}&sourceId=3&simulcastId&videoOnly&videoTargetBitrate=540" \
#-map 0:v:3 -c:v copy -f flv "${RTMP_URL}&sourceId=4&simulcastId&videoOnly&videoTargetBitrate=250" \
#-map 0:v:4 -c:v copy -f flv "${RTMP_URL}&sourceId=5&simulcastId&videoOnly&videoTargetBitrate=200"
#"
#
#
#ffmpeg \
#-nostdin -fflags +genpts -re -stream_loop -1 -i $MEDIA_FILE \
#-map 0:v:0 -map 0:a:0 -c:a copy -c:v copy -f flv "${RTMP_URL}&sourceId=1&simulcastId&videoTargetBitrate=4000" \
#-map 0:v:1 -c:v copy -f flv "${RTMP_URL}&sourceId=2&simulcastId&videoOnly&videoTargetBitrate=1536" \
#-map 0:v:2 -c:v copy -f flv "${RTMP_URL}&sourceId=3&simulcastId&videoOnly&videoTargetBitrate=540" \
#-map 0:v:3 -c:v copy -f flv "${RTMP_URL}&sourceId=4&simulcastId&videoOnly&videoTargetBitrate=250" \
#-map 0:v:4 -c:v copy -f flv "${RTMP_URL}&sourceId=5&simulcastId&videoOnly&videoTargetBitrate=200"

# Configuration
TOTAL_STREAMS=120
BATCH_SIZE=3
BATCH_DELAY=10  # seconds between batches
RECONNECT_INTERVAL=300 # seconds before reconnecting, can be 4(s), 4m,4h, or 0 means never timeout

# Function to start a single stream with auto-reconnect
start_stream() {
    local stream_id=$1

    while true; do
        STREAM_NAME="${BASE_STREAM_NAME}_${stream_id}"
        RTMP_STREAM="${STREAM_NAME}?token=${TOKEN}"
        RTMP_URL="${RTMP_PUBLISH_PATH}/${RTMP_STREAM}${RTMP_PARAMS}"

        # Define the ffmpeg command
        FFMPEG_CMD="ffmpeg \
        -nostdin -fflags +genpts -re -stream_loop -1 -i \"$MEDIA_FILE\" \
        -map 0:v:0 -map 0:a:0 -c:a copy -c:v copy -f flv \"${RTMP_URL}&sourceId=1&simulcastId&videoTargetBitrate=4000\" \
        -map 0:v:1 -c:v copy -f flv \"${RTMP_URL}&sourceId=2&simulcastId&videoOnly&videoTargetBitrate=1536\" \
        -map 0:v:2 -c:v copy -f flv \"${RTMP_URL}&sourceId=3&simulcastId&videoOnly&videoTargetBitrate=540\" \
        -map 0:v:3 -c:v copy -f flv \"${RTMP_URL}&sourceId=4&simulcastId&videoOnly&videoTargetBitrate=250\" \
        -map 0:v:4 -c:v copy -f flv \"${RTMP_URL}&sourceId=5&simulcastId&videoOnly&videoTargetBitrate=200\" \
        > /dev/null 2>&1"

        echo "Starting stream ${stream_id}: ${FFMPEG_CMD}"

        # Use timeout only if RECONNECT_INTERVAL > 0
        if [ "$RECONNECT_INTERVAL" -gt 0 ]; then
            eval "timeout ${RECONNECT_INTERVAL} $FFMPEG_CMD"
        else
            eval "$FFMPEG_CMD"
        fi

        # Check exit status
        EXIT_CODE=$?
        if [ $EXIT_CODE -ne 0 ] && [ $EXIT_CODE -ne 124 ]; then
            # 124 = timeout's exit code (expected), anything else = error
            echo "Stream ${stream_id} failed with exit code ${EXIT_CODE}. Stopping."
            exit 1  # Or 'break' to just exit the loop
        fi

        echo "Stream ${stream_id} disconnected, reconnecting..."
        sleep 0.1  # Brief pause before reconnect
    done
}


# Loop to start streams in batches
for batch in $(seq 0 $((BATCH_SIZE > TOTAL_STREAMS ? TOTAL_STREAMS : BATCH_SIZE)) $((TOTAL_STREAMS-1))); do
    batch_end=$((batch + BATCH_SIZE - 1))
    if [ $batch_end -ge $TOTAL_STREAMS ]; then
        batch_end=$((TOTAL_STREAMS - 1))
    fi

    echo "Starting batch: streams $((batch)) to $((batch_end))"

    # Start streams in current batch
    for i in $(seq $((batch)) $((batch_end))); do
        start_stream $i &
        sleep 0.001
    done

    # Wait before starting next batch (except for last batch)
    if [ $batch_end -lt $((TOTAL_STREAMS - 1)) ]; then
        echo "Waiting ${BATCH_DELAY} seconds before next batch..."
        sleep $BATCH_DELAY
    fi
done


echo "All ${TOTAL_STREAMS} streams started"
echo "Use pkill ffmpeg to kill all process"

wait  # Wait for all background processes (will run indefinitely)
