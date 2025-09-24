#!/usr/bin/env bash
set -euo pipefail

CHANNEL_URL=${CHANNEL_URL:-"https://www.youtube.com/@LTStudioclassroomCom/videos"}
DEST_DIR=${DEST_DIR:-"$(pwd)/downloads"}
ARCHIVE_FILE=${ARCHIVE_FILE:-"$DEST_DIR/.downloaded.txt"}
LOG_FILE=${LOG_FILE:-"$DEST_DIR/yt-dlp.log"}
MAX_DOWNLOADS=${MAX_DOWNLOADS:-1}
FORMAT=${FORMAT:-bestaudio}
AUDIO_FORMAT=${AUDIO_FORMAT:-m4a}
AUDIO_QUALITY=${AUDIO_QUALITY:-5}
OUTPUT_TEMPLATE=${OUTPUT_TEMPLATE:-"%(upload_date>%Y-%m-%d)s - %(title).100s [%(id)s].%(ext)s"}

mkdir -p "$DEST_DIR"
touch "$LOG_FILE"
touch "$ARCHIVE_FILE"

yt-dlp \
  -i \
  -f "$FORMAT" \
  -x --audio-format "$AUDIO_FORMAT" \
  --audio-quality "$AUDIO_QUALITY" \
  --download-archive "$ARCHIVE_FILE" \
  --output "$OUTPUT_TEMPLATE" \
  --paths "$DEST_DIR" \
  --max-downloads "$MAX_DOWNLOADS" \
  --retries 3 \
  --sleep-requests 2 \
  --sleep-interval 2 --max-sleep-interval 5 \
  "$CHANNEL_URL" >> "$LOG_FILE" 2>&1
