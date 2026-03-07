#!/usr/bin/env bash
set -euo pipefail

libreoffice --headless --convert-to pdf 'WEEK1_REPORT_LINKEDIN.html' --outdir .
echo "Generated: WEEK1_REPORT_LINKEDIN.pdf"
