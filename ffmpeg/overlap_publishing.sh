#!/bin/bash
#
# Overlap publishing test.
#
# Two media files are published to the same RTMP URL, alternating:
#   publisher 1 (MEDIA_1) sends for NON_STALL_TIME seconds, then stalls (SIGSTOP:
#   no media, no signaling, socket kept open).
#   OVERLAP_DELAY seconds after that stall starts, publisher 2 (MEDIA_2) starts,
#   sends for NON_STALL_TIME seconds, then stalls.
#   OVERLAP_DELAY seconds later publisher 1 starts again, and so on, until TOTAL_TIME.
#
# A stalled publisher is watched in the background: when the remote (YouTube) closes
# its socket, or after STALL_MAX seconds, the stopped ffmpeg is SIGKILLed so nothing
# buffered is flushed to the remote.
#
# Expected result: the remote switches between media 1 and media 2 with no stall,
# because the next publisher is already sending when the remote gives up on the stalled one.

############### timing (seconds) - change here
NON_STALL_TIME=15   # how long each publisher sends before it stalls
OVERLAP_DELAY=3     # stall start -> next publisher start
TOTAL_TIME=120      # stop starting new publishers after this
STALL_MAX=60        # kill a stalled publisher even if the remote never closes

############### media
MEDIA_PATH="$HOME/working/test_media"
MEDIA_1="$MEDIA_PATH/test_h264_nobf_gop1s.mp4"         # file generated for theo.sh
MEDIA_2="$MEDIA_PATH/media2_test_h264_nobf_gop1s.mp4"  # file provided by the user

############### youtube
RTMP_PUBLISH_PATH="rtmp://a.rtmp.youtube.com/live2"
RTMP_STREAM="j4eb-jq0y-hp4m-43es-1y15"
RTMP_URL="${RTMP_PUBLISH_PATH}/${RTMP_STREAM}"

V_CODEC="copy"
A_CODEC="copy"

LOG_DIR="$(pwd)/overlap_logs"
mkdir -p "$LOG_DIR"

for f in "$MEDIA_1" "$MEDIA_2"; do
    [ -f "$f" ] || { echo "missing media file: $f"; exit 1; }
done

RTMP_PORT=$(echo "$RTMP_PUBLISH_PATH" | sed -n 's#^rtmp://[^/:]*:\([0-9]*\).*#\1#p')
RTMP_PORT=${RTMP_PORT:-1935}

ALL_PIDS=""
cleanup() {
    for p in $ALL_PIDS; do kill -KILL "$p" 2>/dev/null; done
}
trap cleanup EXIT INT TERM

log() { echo "[$(date +%T)] $*"; }

rtmp_socket_state() {
    # print the TCP state of a pid's connection to the RTMP server port, or "GONE"
    local pid=$1 port=$2 state
    if command -v ss >/dev/null 2>&1; then
        state=$(ss -tnp 2>/dev/null | awk -v p="pid=$pid," -v port=":$port" \
            'index($0,p) && index($5,port) {print $1; exit}')
    else  # macOS
        state=$(lsof -nP -a -p "$pid" -iTCP 2>/dev/null | awk -v port=":$port" \
            'index($9,port) {gsub(/[()]/,"",$10); print $10; exit}')
    fi
    echo "${state:-GONE}"
}

start_publisher() {
    # $1 = media file, $2 = label; sets PUB_PID
    local media=$1 label=$2
    # exec so $! is ffmpeg itself, not a forked subshell
    exec ffmpeg -nostdin -hide_banner -loglevel warning -fflags +genpts -re -stream_loop -1 \
        -i "$media" -c:a "$A_CODEC" -c:v "$V_CODEC" -f flv "$RTMP_URL" \
        >"$LOG_DIR/$label.log" 2>&1 &
    PUB_PID=$!
    disown "$PUB_PID"   # no "Killed" job notice from bash when the watcher kills it
    ALL_PIDS="$ALL_PIDS $PUB_PID"
    log "$label: started ffmpeg pid $PUB_PID ($(basename "$media"))"
}

watch_stalled() {
    # $1 = pid, $2 = label. Runs in the background. Kills the stopped ffmpeg when the
    # remote closes the socket (CLOSE-WAIT / GONE) or after STALL_MAX seconds.
    local pid=$1 label=$2 t0 state
    t0=$(date +%s)
    while :; do
        state=$(rtmp_socket_state "$pid" "$RTMP_PORT")
        case "$state" in
            ESTAB|ESTABLISHED) ;;
            *) log "$label: remote closed the connection ($state) after $(( $(date +%s) - t0 ))s of stall"; break ;;
        esac
        if [ $(( $(date +%s) - t0 )) -ge "$STALL_MAX" ]; then
            log "$label: remote did not close within ${STALL_MAX}s"; break
        fi
        sleep 1
    done
    kill -KILL "$pid" 2>/dev/null
    log "$label: ffmpeg pid $pid killed (no flush)"
}

echo "$RTMP_URL"
log "NON_STALL_TIME=${NON_STALL_TIME}s OVERLAP_DELAY=${OVERLAP_DELAY}s TOTAL_TIME=${TOTAL_TIME}s STALL_MAX=${STALL_MAX}s"

START=$(date +%s)
n=0
while [ $(( $(date +%s) - START )) -lt "$TOTAL_TIME" ]; do
    n=$((n + 1))
    if [ $((n % 2)) -eq 1 ]; then media=$MEDIA_1; else media=$MEDIA_2; fi
    label="pub${n}_media$(( (n - 1) % 2 + 1 ))"

    start_publisher "$media" "$label"
    sleep "$NON_STALL_TIME"

    if ! kill -0 "$PUB_PID" 2>/dev/null; then
        log "$label: ffmpeg exited early, see $LOG_DIR/$label.log"
        continue
    fi
    log "$label: stall start (SIGSTOP) - socket stays open, nothing is sent"
    kill -STOP "$PUB_PID"
    watch_stalled "$PUB_PID" "$label" &

    sleep "$OVERLAP_DELAY"
done

log "TOTAL_TIME reached, waiting for the remaining stalled publishers to be closed"
wait
log "done, ffmpeg logs are in $LOG_DIR"
trap - EXIT
