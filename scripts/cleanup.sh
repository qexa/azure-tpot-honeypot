#!/usr/bin/env bash
set -euo pipefail

RG="${1:-rg-tpot-honeypot}"
echo "[!] This will delete ENTIRE resource group: ${RG}"
read -p "Type the resource group name to confirm: " confirm
[ "$confirm" = "$RG" ] || { echo "Mismatch. Aborting."; exit 1; }

az group delete -n "$RG" --yes
echo "[+] Deletion requested."
