#!/usr/bin/env bash
# Chart Render API – cURL example
# Usage: CHARTQUERY_API_KEY=your-key bash chart.sh
set -euo pipefail

curl -sS -G "https://api.chartquery.com/v1/chart" \
  -H "x-api-key: ${CHARTQUERY_API_KEY}" \
  --data-urlencode 'query={"type":"bar","title":"Monthly Sales","legend":"bottom","width":1200,"height":600,"device_pixel_ratio":1,"data":{"labels":["Jan","Feb","Mar","Apr","May","Jun"],"datasets":[{"label":"2025","data":[42,58,37,65,49,72],"backgroundColor":"rgba(99,102,241,0.85)"},{"label":"2026","data":[51,67,44,71,58,85],"backgroundColor":"rgba(249,115,22,0.85)"}]},"scales":{"y":{"beginAtZero":true}}}' \
  -o chart.png

echo "Saved chart.png"
