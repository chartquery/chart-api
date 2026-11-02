#!/usr/bin/env bash
# AI Chart API – cURL example
# Usage: CHARTQUERY_API_KEY=your-key bash chart_ai.sh
set -euo pipefail

curl -sS --fail-with-body -G "https://api.chartquery.com/v1/chart/ai" \
  -H "x-api-key: ${CHARTQUERY_API_KEY}" \
  --data-urlencode 'prompt=Bar chart of monthly sales from January to June, indigo bars, clean style' \
  --data-urlencode format=png \
  -o ai-chart.png

echo "Saved ai-chart.png"
