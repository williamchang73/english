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

Set `TRACE=1` to echo each command and status message while keeping logs under `downloads/yt-dlp.log`:

```bash
TRACE=1 scripts/download_latest_audio.sh
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
2. Downloads the newest unseen video as an audio file into `downloads/` using `scripts/download_latest_audio.sh` (run with `TRACE=1` so every command is echoed to the job log).
   - If `yt-dlp` reports exit code `101`, the script treats it as “no new videos” and the job continues without failing.
3. Regenerates `docs/index.html` via `scripts/generate_downloads_html.py`.
4. Uploads the audio directory as a workflow artifact (`youtube-audio`).
5. Commits and pushes repository changes (audio files + HTML index) when new content appears.

Workflow logs are written to `downloads/yt-dlp.log`. Successful “no new video” runs append a message there so you can verify the archive check.

Enable GitHub Pages (Docs folder) to surface the HTML table on the web.
