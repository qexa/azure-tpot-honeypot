# Azure T-Pot Honeypot

Turn-key deployment of the **T-Pot** multi-honeypot platform on **Azure VM**, adapted from common cloud guides and tailored to Azure networking, disks, and automation.

> ⚠️ Deploy in an **isolated research environment** only. Honeypots attract malicious traffic by design.

## Features
- Azure CLI script and ARM/Terraform options
- NSG configured to expose honeypot ports widely while restricting **SSH** and **Web UI** to your IP
- Optional daily reboot & log retention
- Basic CI workflow and docs

## Quick Start (Script)
```bash
# 1) Clone & configure
git clone https://github.com/qexa/azure-tpot-honeypot.git
cd azure-tpot-honeypot
cp .env.example .env
# edit .env with your values (subscription, ssh key, allowed IP, etc.)

# 2) Deploy infra + VM
chmod +x scripts/deploy-tpot.sh
./scripts/deploy-tpot.sh

# 3) Install T-Pot on the VM (script runs this remotely or SSH and run)
# Access Web UI after ~10 min: https://<PUBLIC_IP>:64297
```

## Quick Start (Terraform)
```bash
cd terraform
terraform init
terraform plan -out tf.plan
terraform apply tf.plan
```

## Access
- SSH: `ssh -p 64295 tpotadmin@<PUBLIC_IP>`
- Web UI: `https://<PUBLIC_IP>:64297` (user/pass from `.env`)

## Repository Layout
```
scripts/         # deploy/install/cleanup/export
templates/       # ARM template + parameters
terraform/       # Terraform IaC
docs/            # installation & troubleshooting
.github/         # CI workflow and issue templates
configs/         # example T-Pot overrides
examples/        # sample usage
tests/           # basic validation scripts
```

## Security Notes
- Restrict **SSH** (64295) and **Web UI** (64297) to your IP(s) only.
- Leave honeypot ports open to attract unsolicited traffic.
- Never mix this with production assets.

## Roadmap
- Sentinel/Defender integrations
- Dashboards & exporters
- Azure Policy baselines
