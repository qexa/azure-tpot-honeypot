#!/usr/bin/env bash
set -euo pipefail

EXPORT_DIR="/tmp/tpot-export-$(date +%Y%m%d-%H%M%S)"
TIMEFRAME="${1:-24h}"
mkdir -p "$EXPORT_DIR"

echo "[+] Exporting Elasticsearch data for timeframe ${TIMEFRAME}"
curl -s -X GET "localhost:9200/logstash-*/_search?size=10000&q=@timestamp:[now-${TIMEFRAME} TO now]" \
  -H 'Content-Type: application/json' \
  -o "${EXPORT_DIR}/attacks-${TIMEFRAME}.json"

tar -czf "tpot-data-export-$(date +%Y%m%d-%H%M%S).tar.gz" -C /tmp "$(basename "$EXPORT_DIR")"
echo "[+] Wrote archive: $(pwd)/tpot-data-export-*.tar.gz"
