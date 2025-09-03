#!/usr/bin/env bash
set -euo pipefail

echo "[+] Checking bash syntax for scripts"
bash -n scripts/deploy-tpot.sh
bash -n scripts/install-tpot.sh
bash -n scripts/export-data.sh
bash -n scripts/cleanup.sh
echo "[+] OK"
