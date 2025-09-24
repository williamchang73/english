#!/usr/bin/env bash
set -euo pipefail

# ====== CONFIG ======
CHANNEL_URL="https://www.youtube.com/@LTStudioclassroomCom/videos"
DEST_DIR="/Users/william_chang/workspace/english/Videos/ChannelDownloads"
ARCHIVE_FILE="$DEST_DIR/.downloaded.txt"
LOG_FILE="$DEST_DIR/yt-dlp.log"
# ====================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

CHANNEL_URL="$CHANNEL_URL" \
DEST_DIR="$DEST_DIR" \
ARCHIVE_FILE="$ARCHIVE_FILE" \
LOG_FILE="$LOG_FILE" \
"$SCRIPT_DIR/scripts/download_latest_audio.sh"
