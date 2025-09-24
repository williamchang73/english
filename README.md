# YouTube Daily Audio Downloader

This project automates daily audio downloads from a specified YouTube channel. A reusable shell script fetches the latest upload with `yt-dlp`, stores the audio file under `downloads/`, and a Python helper builds a simple HTML index at `docs/index.html` listing every captured file by date.

## Local usage

Requirements:

- Python 3.9+
- `yt-dlp` available on your PATH (`pip install yt-dlp`)

```bash
scripts/download_latest_audio.sh
python3 scripts/generate_downloads_html.py
```

Override defaults with environment variables, for example:

```bash
CHANNEL_URL="https://www.youtube.com/@example/videos" \
DEST_DIR="$PWD/custom-downloads" \
OUTPUT_FILE="$PWD/docs/index.html" \
scripts/download_latest_audio.sh
python3 scripts/generate_downloads_html.py
```

## GitHub Actions workflow

The workflow in `.github/workflows/daily-download.yml` runs daily (12:00 UTC) and on manual dispatch:

1. Installs `yt-dlp`.
2. Downloads the newest unseen video as an audio file into `downloads/` using `scripts/download_latest_audio.sh`.
3. Regenerates `docs/index.html` via `scripts/generate_downloads_html.py`.
4. Uploads the audio directory as a workflow artifact (`youtube-audio`).
5. Commits and pushes repository changes (audio files + HTML index) when new content appears.

Enable GitHub Pages (Docs folder) to surface the HTML table on the web.
