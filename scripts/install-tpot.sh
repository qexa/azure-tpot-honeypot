#!/usr/bin/env bash
set -euo pipefail

TPOT_TYPE="${1:-hive}"
WEB_USER="${2:-admin}"
WEB_PASS="${3:-ChangeMe123!}"
SSH_PORT="${4:-64295}"
WEBUI_PORT="${5:-64297}"

echo "[+] Updating system..."
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y curl git jq ufw

echo "[+] Set custom SSH port ${SSH_PORT}"
sudo sed -i "s/^#\?Port .*/Port ${SSH_PORT}/" /etc/ssh/sshd_config
sudo systemctl restart ssh

echo "[+] Install Docker"
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER || true

echo "[+] Install T-Pot (community edition)"
# Official docs use installer. For simplicity we follow the one-liner fetch.
# Reference: https://github.com/telekom-security/tpotce
cd ~
git clone https://github.com/telekom-security/tpotce.git
cd tpotce/iso/installer

# Non-interactive install using defaults where possible
sudo ./install.sh --type "${TPOT_TYPE}" --user "${WEB_USER}" --password "${WEB_PASS}" --accept-license

echo "[+] Configure firewall (ufw) for WEBUI ${WEBUI_PORT} and SSH ${SSH_PORT}"
sudo ufw allow ${SSH_PORT}/tcp
sudo ufw allow ${WEBUI_PORT}/tcp
sudo ufw --force enable || true

echo "[+] Adjust T-Pot HTTP(S) proxy port if required (defaults are fine for most)"
# T-Pot defaults to web interface on 64297 for Cockpit/Grafana (varies by version).
# To hard-pin, we'd alter docker-compose or service mapping here if needed.

echo "[+] Enable daily reboot at 02:42 if requested"
if [ "${DAILY_REBOOT:-true}" = "true" ]; then
  echo "42 2 * * * root /sbin/reboot" | sudo tee /etc/cron.d/tpot-daily-reboot >/dev/null
fi

echo "[+] Installation complete. T-Pot services might take ~5-10 minutes to fully initialize."
