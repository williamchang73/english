#!/usr/bin/env python3
import os
import sys
from pathlib import Path
from urllib.parse import quote

DEST_DIR = Path(os.environ.get("DEST_DIR", Path.cwd() / "downloads")).resolve()
OUTPUT_FILE = Path(os.environ.get("OUTPUT_FILE", Path.cwd() / "docs/index.html")).resolve()

files = []
if DEST_DIR.exists():
    for candidate in DEST_DIR.iterdir():
        if candidate.is_file() and not candidate.name.startswith('.'):
            files.append(candidate)

files.sort(key=lambda p: p.name, reverse=True)

OUTPUT_FILE.parent.mkdir(parents=True, exist_ok=True)

rows = []
for path in files:
    name = path.name
    date_part = name[:10]
    date_display = date_part if date_part.replace('-', '').isdigit() else "Unknown"
    rel_path = Path(os.path.relpath(path, OUTPUT_FILE.parent))
    link = quote(str(rel_path).replace(os.sep, '/'))
    rows.append(f"      <tr><td>{date_display}</td><td><a href=\"{link}\">{name}</a></td></tr>")

html = """<!DOCTYPE html>
<html lang=\"en\">
  <head>
    <meta charset=\"utf-8\" />
    <title>YouTube Audio Downloads</title>
    <style>
      body { font-family: system-ui, sans-serif; padding: 2rem; }
      table { border-collapse: collapse; width: 100%; max-width: 960px; }
      th, td { border: 1px solid #ccc; padding: 0.5rem 0.75rem; text-align: left; }
      th { background: #f0f0f0; }
      tbody tr:nth-child(even) { background: #fafafa; }
    </style>
  </head>
  <body>
    <h1>YouTube Audio Downloads</h1>
    <table>
      <thead>
        <tr><th>Date</th><th>File Link</th></tr>
      </thead>
      <tbody>
{rows}
      </tbody>
    </table>
  </body>
</html>
""".replace("{rows}", "\n".join(rows) if rows else "      <tr><td colspan=\"2\">No downloads yet.</td></tr>")

OUTPUT_FILE.write_text(html, encoding="utf-8")
