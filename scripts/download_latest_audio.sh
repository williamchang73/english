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
TRACE=${TRACE:-}

mkdir -p "$DEST_DIR"
touch "$LOG_FILE"
touch "$ARCHIVE_FILE"

if [[ -n "$TRACE" && "$TRACE" != "0" ]]; then
  set -x
fi

timestamp=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
echo "[INFO] ${timestamp} Starting download run" | tee -a "$LOG_FILE"
echo "[INFO] Channel URL: $CHANNEL_URL" | tee -a "$LOG_FILE"
echo "[INFO] Destination directory: $DEST_DIR" | tee -a "$LOG_FILE"
echo "[INFO] Archive file: $ARCHIVE_FILE" | tee -a "$LOG_FILE"

set +e
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
  "$CHANNEL_URL" 2>&1 | tee -a "$LOG_FILE"
status=$?
set -e

if [[ $status -ne 0 && $status -ne 101 ]]; then
  echo "[ERROR] yt-dlp failed with exit code $status" | tee -a "$LOG_FILE"
  exit $status
fi

if [[ $status -eq 101 ]]; then
  echo "[INFO] No new videos to download; yt-dlp reported exit code 101." | tee -a "$LOG_FILE"
else
  echo "[INFO] Download finished successfully." | tee -a "$LOG_FILE"
fi
