# Installation

## Prereqs
- Azure subscription + `az` CLI logged in
- SSH public key
- A public IP (CIDR /32) to restrict management access

## Steps (scripted)
1. `cp .env.example .env` and edit with your values.
2. `chmod +x scripts/deploy-tpot.sh`
3. `./scripts/deploy-tpot.sh`
4. Wait ~10 minutes for T-Pot to initialize.
5. Access: `https://<PUBLIC_IP>:64297`

## Steps (Terraform)
```bash
cd terraform
terraform init
terraform apply
```
