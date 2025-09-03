# Troubleshooting

## Can't SSH
- Ensure your IP in `.env` matches `ALLOWED_IPS`.
- Confirm NSG rules: `az network nsg rule list -g <rg> -n nsg-tpot -o table`
- Use the right port: `ssh -p 64295 tpotadmin@<PUBLIC_IP>`

## Web UI not reachable
- Check containers: `docker ps`
- Check ufw: `sudo ufw status`
- Some services take 5–10 minutes to warm up after install.

## High disk usage
- Prune old images/logs: `docker system prune -f`
- Consider attaching a data disk for logs.
