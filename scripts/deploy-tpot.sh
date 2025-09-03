#!/usr/bin/env bash
set -euo pipefail

echo "[+] Loading .env ..."
if [ -f ".env" ]; then
  set -a; source .env; set +a
else
  echo "Missing .env (copy from .env.example)"; exit 1
fi

: "${AZURE_SUBSCRIPTION_ID:?}"
: "${AZURE_RESOURCE_GROUP:?}"
: "${AZURE_LOCATION:?}"
: "${VM_NAME:?}"
: "${VM_SIZE:?}"
: "${ADMIN_USERNAME:?}"
: "${SSH_PUBLIC_KEY:?}"
: "${SSH_PORT:=64295}"
: "${WEBUI_PORT:=64297}"
: "${ALLOWED_IPS:?}"

echo "[+] Azure login/subscription check (you must be logged in)"
az account show >/dev/null 2>&1 || { echo "Run: az login"; exit 1; }
az account set --subscription "$AZURE_SUBSCRIPTION_ID"

echo "[+] Create Resource Group: $AZURE_RESOURCE_GROUP ($AZURE_LOCATION)"
az group create -n "$AZURE_RESOURCE_GROUP" -l "$AZURE_LOCATION" -o none

echo "[+] Create VNet + Subnet"
az network vnet create -g "$AZURE_RESOURCE_GROUP" -n vnet-tpot --address-prefix 10.20.0.0/16 \
  --subnet-name snet-tpot --subnet-prefix 10.20.1.0/24 -o none

echo "[+] Create Public IP"
az network public-ip create -g "$AZURE_RESOURCE_GROUP" -n pip-tpot --sku Standard --allocation-method static -o none

echo "[+] Create NSG and rules"
az network nsg create -g "$AZURE_RESOURCE_GROUP" -n nsg-tpot -o none

# Restrict SSH and WebUI to ALLOWED_IPS
az network nsg rule create -g "$AZURE_RESOURCE_GROUP" --nsg-name nsg-tpot -n allow-ssh \
  --priority 100 --source-address-prefixes "$ALLOWED_IPS" --destination-port-ranges "$SSH_PORT" \
  --protocol Tcp --access Allow --direction Inbound -o none

az network nsg rule create -g "$AZURE_RESOURCE_GROUP" --nsg-name nsg-tpot -n allow-webui \
  --priority 110 --source-address-prefixes "$ALLOWED_IPS" --destination-port-ranges "$WEBUI_PORT" \
  --protocol Tcp --access Allow --direction Inbound -o none

# Broad allow for honeypot ports (be intentional!)
az network nsg rule create -g "$AZURE_RESOURCE_GROUP" --nsg-name nsg-tpot -n allow-honeypot-wide \
  --priority 200 --source-address-prefixes "*" --destination-port-ranges 1-64000 \
  --protocol Tcp --access Allow --direction Inbound -o none

echo "[+] Create NIC"
az network nic create -g "$AZURE_RESOURCE_GROUP" -n nic-tpot \
  --vnet-name vnet-tpot --subnet snet-tpot --network-security-group nsg-tpot --public-ip-address pip-tpot -o none

echo "[+] Create VM (Ubuntu LTS)"
az vm create -g "$AZURE_RESOURCE_GROUP" -n "$VM_NAME" \
  --image Ubuntu2204 --size "$VM_SIZE" \
  --admin-username "$ADMIN_USERNAME" \
  --ssh-key-values "$SSH_PUBLIC_KEY" \
  --nics nic-tpot --os-disk-size-gb 256 \
  --public-ip-address pip-tpot -o json > /tmp/tpot-vm.json

PUBLIC_IP=$(jq -r '.publicIpAddress' /tmp/tpot-vm.json)
echo "[+] VM Public IP: $PUBLIC_IP"

echo "[+] Open outbound as default (inbound controlled via NSG)"
# No extra steps; Azure outbound is open by default for standard scenarios.

echo "[+] Copy install script and run remotely"
scp -o StrictHostKeyChecking=no -P 22 scripts/install-tpot.sh "${ADMIN_USERNAME}@${PUBLIC_IP}:/tmp/install-tpot.sh"
ssh -o StrictHostKeyChecking=no "${ADMIN_USERNAME}@${PUBLIC_IP}" "chmod +x /tmp/install-tpot.sh && sudo /tmp/install-tpot.sh ${TPOT_TYPE:-hive} ${WEB_USER:-admin} ${WEB_PASSWORD:-ChangeMe123!} ${SSH_PORT} ${WEBUI_PORT}"

echo "[+] Done. Access:"
echo "    SSH:    ssh -p ${SSH_PORT} ${ADMIN_USERNAME}@${PUBLIC_IP}"
echo "    WebUI:  https://${PUBLIC_IP}:${WEBUI_PORT}"
