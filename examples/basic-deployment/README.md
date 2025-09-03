# Basic Deployment

```
cp .env.example .env
# Fill AZURE_SUBSCRIPTION_ID, SSH_PUBLIC_KEY, and ALLOWED_IPS
./scripts/deploy-tpot.sh
```
Access after initialization:
- SSH: `ssh -p 64295 tpotadmin@<PUBLIC_IP>`
- Web: `https://<PUBLIC_IP>:64297`
