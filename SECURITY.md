# Security Policy

If you discover a vulnerability, please email **alexander@qexa.com** with subject `[SECURITY] Azure T-Pot`.
Include a detailed description, steps to reproduce, and potential impact.

**Best practices for operators:**
- Deploy in isolated subscriptions/VNETs dedicated to research.
- Restrict management ports (SSH/Web UI) to your IPs only.
- Do not store sensitive data on the honeypot.
- Regularly update packages and review NSG rules.
