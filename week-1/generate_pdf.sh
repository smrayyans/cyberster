#!/usr/bin/env bash
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
SRC_HTML="$HERE/WEEK1_REPORT_LINKEDIN.html"
EMBED_HTML="$HERE/WEEK1_REPORT_LINKEDIN.embedded.html"
OUT_PDF="$HERE/WEEK1_REPORT_LINKEDIN.pdf"

HERE="$HERE" python3 - <<'PY'
import base64
import os
import mimetypes
import re
from pathlib import Path

here = Path(os.environ["HERE"])
src = here / "WEEK1_REPORT_LINKEDIN.html"
out = here / "WEEK1_REPORT_LINKEDIN.embedded.html"
html = src.read_text(encoding="utf-8")

pattern = re.compile(r'src="([^"]+)"')

def repl(match):
    rel = match.group(1)
    p = (here / rel).resolve()
    if not p.exists():
        return match.group(0)
    mime, _ = mimetypes.guess_type(str(p))
    if not mime:
        mime = "application/octet-stream"
    data = base64.b64encode(p.read_bytes()).decode("ascii")
    return f'src="data:{mime};base64,{data}"'

embedded = pattern.sub(repl, html)
out.write_text(embedded, encoding="utf-8")
PY

chromium \
  --headless \
  --disable-gpu \
  --no-sandbox \
  --no-pdf-header-footer \
  --allow-file-access-from-files \
  --print-to-pdf="$OUT_PDF" \
  "file://$EMBED_HTML"

echo "Generated: $OUT_PDF (images embedded)"
