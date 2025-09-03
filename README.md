# Azure T-Pot Honeypot Deployment

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub issues](https://img.shields.io/github/issues/qexa/azure-tpot-honeypot)](https://github.com/qexa/azure-tpot-honeypot/issues)
[![GitHub stars](https://img.shields.io/github/stars/qexa/azure-tpot-honeypot)](https://github.com/qexa/azure-tpot-honeypot/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/qexa/azure-tpot-honeypot)](https://github.com/qexa/azure-tpot-honeypot/network)
[![Azure](https://img.shields.io/badge/Azure-Ready-blue.svg)](https://azure.microsoft.com)

> Complete deployment guide and automation scripts for running T-Pot honeypot platform on Azure Virtual Machines with comprehensive security monitoring and threat intelligence collection.

## 📖 Table of Contents

- [Features](#-features)
- [Architecture](#-architecture)
- [Prerequisites](#-prerequisites)
- [Quick Start](#-quick-start)
- [Deployment Methods](#-deployment-methods)
- [Configuration](#-configuration)
- [Monitoring & Analytics](#-monitoring--analytics)
- [Security Considerations](#-security-considerations)
- [Troubleshooting](#-troubleshooting)
- [Contributing](#-contributing)
- [Documentation](#-documentation)
- [Support](#-support)
- [License](#-license)
- [About Qexa Technology](#-about-qexa-technology)

## ✨ Features

- 🛡️ **Multi-Honeypot Platform** - 20+ honeypots including Cowrie, Dionaea, Conpot, and more
- ☁️ **Azure-Optimized** - Pre-configured for Azure VMs with cost optimization
- 📊 **Real-Time Analytics** - Kibana dashboards and attack visualization
- 🤖 **AI-Enhanced Detection** - LLM-based honeypots (Beelzebub & Galah)
- 🔒 **Security Hardened** - NSG configurations and access controls
- 📈 **Scalable Architecture** - Support for single instance or distributed deployment
- 🔧 **Automated Setup** - One-click deployment scripts and ARM templates
- 📱 **Mobile Dashboard** - Responsive web interface for monitoring
- 🌍 **Threat Intelligence** - Geolocation tracking and attack pattern analysis
- 💾 **Data Export** - Multiple formats for threat intelligence sharing

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Azure Cloud                          │
│  ┌─────────────────────────────────────────────────────┐ │
│  │                Resource Group                        │ │
│  │  ┌─────────────────┐    ┌─────────────────────────┐ │ │
│  │  │   Azure VM      │    │    Network Security     │ │ │
│  │  │   (T-Pot Host)  │◄───┤         Group           │ │ │
│  │  │                 │    │                         │ │ │
│  │  │  ┌─────────────┐│    │  • SSH (64295)          │ │ │
│  │  │  │   Docker    ││    │  • WebUI (64297)        │ │ │
│  │  │  │ Containers  ││    │  • Honeypots (1-64000)  │ │ │
│  │  │  │             ││    └─────────────────────────┘ │ │
│  │  │  │ • Cowrie    ││                                │ │
│  │  │  │ • Dionaea   ││    ┌─────────────────────────┐ │ │
│  │  │  │ • Kibana    ││    │      Public IP          │ │ │
│  │  │  │ • Elastic   ││◄───┤     (Static)            │ │ │
│  │  │  │ • Suricata  ││    └─────────────────────────┘ │ │
│  │  │  └─────────────┘│                                │ │
│  │  └─────────────────┘                                │ │
│  └─────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────┘
```

## 🔧 Prerequisites

### Required Knowledge
- Basic Azure portal navigation and CLI usage
- SSH and Linux command line operations
- Understanding of network security concepts
- Docker containers fundamentals

### Azure Requirements
- Active Azure subscription
- Permissions to create VMs, NSGs, and Public IPs
- Available quota for chosen VM size
- Understanding of Azure billing and cost management

### System Requirements

| Component | Sensor (Minimum) | Hive (Recommended) |
|-----------|------------------|-------------------|
| **VM Size** | Standard_D2s_v3 | Standard_D4s_v3 |
| **vCPUs** | 2 | 4 |
| **RAM** | 8GB | 16GB |
| **Storage** | 128GB Premium SSD | 256GB Premium SSD |
| **Network** | Public IP + NSG | Public IP + NSG |

## 🚀 Quick Start

### Method 1: Azure CLI (Recommended)

```bash
# Clone this repository
git clone https://github.com/qexa/azure-tpot-honeypot.git
cd azure-tpot-honeypot

# Make deployment script executable
chmod +x scripts/deploy-tpot.sh

# Run automated deployment
./scripts/deploy-tpot.sh
```

### Method 2: Manual Portal Deployment

1. **Create Resource Group**
   ```bash
   az group create --name rg-tpot-honeypot --location eastus
   ```

2. **Deploy VM using ARM Template**
   ```bash
   az deployment group create \
     --resource-group rg-tpot-honeypot \
     --template-file templates/tpot-vm.json \
     --parameters @templates/parameters.json
   ```

3. **Run T-Pot Installation**
   ```bash
   ssh azureuser@<your-public-ip>
   curl -sSL https://raw.githubusercontent.com/qexa/azure-tpot-honeypot/main/scripts/install-tpot.sh | bash
   ```

## 📦 Deployment Methods

### 1. Automated Script Deployment

Our deployment script handles everything automatically:

```bash
# Full automated deployment
./scripts/deploy-tpot.sh --resource-group rg-tpot --location eastus --vm-size Standard_D4s_v3

# Sensor-only deployment (cost-optimized)
./scripts/deploy-tpot.sh --type sensor --vm-size Standard_D2s_v3

# Custom configuration
./scripts/deploy-tpot.sh --config configs/custom-tpot.yml
```

### 2. ARM Template Deployment

Deploy using Azure Resource Manager templates:

```bash
# Deploy infrastructure
az deployment group create \
  --resource-group rg-tpot-honeypot \
  --template-file templates/main.json \
  --parameters vmSize=Standard_D4s_v3 adminUsername=tpotadmin
```

### 3. Terraform Deployment

Infrastructure as Code using Terraform:

```bash
# Initialize Terraform
cd terraform/
terraform init

# Plan deployment
terraform plan -var="admin_username=tpotadmin" -var="location=East US"

# Apply configuration
terraform apply
```

## ⚙️ Configuration

### Environment Variables

Create a `.env` file in the project root:

```bash
# Azure Configuration
AZURE_SUBSCRIPTION_ID=your-subscription-id
AZURE_RESOURCE_GROUP=rg-tpot-honeypot
AZURE_LOCATION=eastus

# VM Configuration  
VM_SIZE=Standard_D4s_v3
ADMIN_USERNAME=tpotadmin
VM_NAME=vm-tpot-honeypot

# T-Pot Configuration
TPOT_TYPE=hive          # Options: hive, sensor, industrial, log4j
WEB_USER=admin
WEB_PASSWORD=SecurePass123!

# Network Configuration
SSH_PORT=64295
WEBUI_PORT=64297
ALLOWED_IPS=YOUR_PUBLIC_IP/32

# Optional Features
ENABLE_BLACKHOLE=true
ENABLE_COMMUNITY_DATA=false
DAILY_REBOOT=true
```

### T-Pot Configuration Files

Customize T-Pot behavior by modifying configuration files:

```yaml
# configs/tpot.yml
tpot:
  version: "24.04.1"
  type: "hive"
  
  honeypots:
    cowrie:
      enabled: true
      ports: [22, 23]
    dionaea:
      enabled: true  
      ports: [21, 42, 135, 443, 1433, 3306]
    conpot:
      enabled: true
      ports: [80, 102, 502, 44818]
      
  security:
    blackhole_mode: true
    daily_reboot: "02:42"
    auto_update: true
    
  logging:
    retention_days: 30
    export_format: ["json", "csv"]
```

## 📊 Monitoring & Analytics

### Kibana Dashboard Access

1. **Web Interface**: `https://<your-public-ip>:64297`
2. **Default Login**: Use credentials set during installation
3. **Available Dashboards**:
   - Attack Map (real-time visualization)
   - Honeypot Statistics
   - Geographic Analysis
   - Timeline Analysis
   - Threat Intelligence

### Key Metrics to Monitor

```bash
# Check T-Pot service status
systemctl status tpot

# Monitor container health
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# View attack statistics
curl -s http://localhost:9200/_cat/indices?v | grep logstash

# Check disk usage
df -h /opt/tpot/data
```

### Data Export Scripts

Export collected data for analysis:

```bash
# Export last 24 hours of attacks
./scripts/export-data.sh --timeframe 24h --format json

# Export specific honeypot data
./scripts/export-data.sh --honeypot cowrie --format csv

# Export geolocation data
./scripts/export-data.sh --include-geo --format elasticsearch
```

## 🔒 Security Considerations

### Network Security Groups (NSG)

Our deployment automatically configures NSG rules:

| Priority | Name | Port | Source | Purpose |
|----------|------|------|--------|---------|
| 100 | AllowSSH | 64295 | Your IP | Remote management |
| 110 | AllowWebUI | 64297 | Your IP | Dashboard access |
| 120 | AllowHoneypots | 1-64000 | Any | Honeypot services |
| 4000 | DenyAll | * | Any | Default deny |

### Security Best Practices

1. **Restrict Management Access**
   ```bash
   # Update NSG to allow only your IP
   az network nsg rule update \
     --resource-group rg-tpot-honeypot \
     --nsg-name vm-tpot-honeypotNSG \
     --name AllowSSH \
     --source-address-prefixes YOUR_NEW_IP/32
   ```

2. **Enable Azure Security Center**
   ```bash
   # Enable security recommendations
   az security auto-provisioning-setting update --name default --auto-provision on
   ```

3. **Regular Updates**
   ```bash
   # Update T-Pot (automated daily)
   sudo /opt/tpot/bin/update.sh
   
   # Update Azure VM
   sudo apt update && sudo apt upgrade -y
   ```

### Data Privacy & Compliance

- All collected data is stored locally on the VM
- Optional community data sharing can be disabled
- GDPR-compliant data handling procedures included
- Data retention policies configurable (default: 30 days)

## 🛠️ Troubleshooting

### Common Issues

#### SSH Connection Problems
```bash
# Check if VM is running
az vm get-instance-view --resource-group rg-tpot-honeypot --name vm-tpot-honeypot

# Verify NSG rules
az network nsg rule list --resource-group rg-tpot-honeypot --nsg-name vm-tpot-honeypotNSG --output table

# Reset SSH port (if needed)
az vm run-command invoke --resource-group rg-tpot-honeypot --name vm-tpot-honeypot --command-id RunShellScript --scripts "sudo ufw allow 22/tcp"
```

#### Container Issues
```bash
# Check container status
docker ps -a

# View container logs
docker logs tpot

# Restart T-Pot service
sudo systemctl restart tpot

# Check system resources
htop
df -h
```

#### Performance Issues
```bash
# Monitor resource usage
docker stats

# Check memory usage
free -h

# Optimize for lower resource usage
sudo nano ~/tpotce/.env
# Add: TPOT_TYPE=sensor
sudo systemctl restart tpot
```

### Log Analysis

```bash
# View T-Pot initialization logs
cat ~/tpotce/data/tpotinit.log

# Check Elasticsearch status
curl -X GET "localhost:9200/_cluster/health?pretty"

# View recent attacks
curl -X GET "localhost:9200/logstash-*/_search?pretty&size=10&sort=@timestamp:desc"
```

## 🤝 Contributing

We welcome contributions to improve this Azure T-Pot deployment! Here's how you can help:

### Development Setup

```bash
# Fork and clone the repository
git clone https://github.com/yourusername/azure-tpot-honeypot.git
cd azure-tpot-honeypot

# Create a feature branch
git checkout -b feature/your-feature-name

# Make your changes and test
./scripts/test-deployment.sh

# Commit and push
git commit -m "feat: add new feature description"
git push origin feature/your-feature-name
```

### Areas for Contribution

- **ARM Templates** - Improve infrastructure automation
- **Monitoring Scripts** - Enhanced analytics and alerting
- **Security Enhancements** - Additional hardening measures  
- **Documentation** - User guides and troubleshooting
- **Cost Optimization** - Resource efficiency improvements

### Testing

```bash
# Run deployment tests
./tests/test-deployment.sh

# Validate ARM templates
az deployment group validate --resource-group test-rg --template-file templates/main.json

# Security scan
./scripts/security-scan.sh
```

## 📚 Documentation

### Quick Reference Guides
- [Installation Guide](./docs/installation.md)
- [Configuration Reference](./docs/configuration.md)
- [Troubleshooting Guide](./docs/troubleshooting.md)
- [Security Best Practices](./docs/security.md)

### Advanced Topics
- [Scaling T-Pot Deployments](./docs/scaling.md)
- [Custom Honeypot Development](./docs/custom-honeypots.md)
- [Integration with Azure Sentinel](./docs/sentinel-integration.md)
- [Threat Intelligence Sharing](./docs/threat-intel.md)

### API Documentation
- [REST API Reference](./docs/api/README.md)
- [Webhook Configuration](./docs/api/webhooks.md)
- [Data Export API](./docs/api/export.md)

## 🆘 Support

### Getting Help

- 🐛 **Bug Reports**: [GitHub Issues](https://github.com/qexa/azure-tpot-honeypot/issues)
- 💡 **Feature Requests**: [GitHub Discussions](https://github.com/qexa/azure-tpot-honeypot/discussions)
- 📧 **Email Support**: alexander@qexa.com
- 💬 **Community Chat**: [Join our Discord](https://discord.gg/qexa-community)

### Professional Services

Qexa Technology offers professional services for:
- Custom honeypot deployments
- Enterprise security consulting
- SOC integration and training
- Threat hunting workshops

Contact: [alexander@qexa.com](mailto:alexander@qexa.com)

### Community Resources

- **Blog**: [Cybersecurity insights and tutorials](https://qexa.com/blog)
- **LinkedIn**: [Alexander Curtis](https://www.linkedin.com/in/alexanderscurtis/)
- **Twitter**: [@alexandercurtis](https://twitter.com/alexandercurtis)
- **YouTube**: [Security tutorials and demos](https://www.youtube.com/@alexanderscurtis)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### Third-party Components

- **T-Pot**: Licensed under GPL v3.0
- **Docker**: Licensed under Apache License 2.0
- **Elasticsearch**: Licensed under Elastic License
- **Azure SDK**: Licensed under MIT License

See [THIRD_PARTY_LICENSES.md](THIRD_PARTY_LICENSES.md) for complete details.

## 🏢 About Qexa Technology

**Qexa Technology** is a cybersecurity consulting firm based in Nashville, TN, specializing in:

- **SOC Development & Operations**
- **Threat Hunting & Detection Engineering**  
- **Security Architecture & Implementation**
- **Incident Response & Forensics**
- **Cybersecurity Training & Education**

### Our Mission
Democratizing cybersecurity through practical, hands-on education and affordable security solutions for organizations of all sizes.

### Other Projects
- [Threat Hunting Scenarios](https://github.com/qexa/Threat-Hunting-Scenario-Tor-Browser-Detection)
- [PiSOC - Raspberry Pi SOC Lab](https://github.com/qexa/PiSOC-MiniSOC)
- [PiSOC Dashboard](https://github.com/qexa/pisoc-dashboard)

---

## 📊 Project Stats

![GitHub repo size](https://img.shields.io/github/repo-size/qexa/azure-tpot-honeypot)
![GitHub commit activity](https://img.shields.io/github/commit-activity/m/qexa/azure-tpot-honeypot)
![GitHub last commit](https://img.shields.io/github/last-commit/qexa/azure-tpot-honeypot)
![Azure](https://img.shields.io/badge/Tested%20on-Azure-blue.svg)

**⚠️ Security Notice**: This honeypot is designed to attract malicious traffic. Deploy only in isolated environments and never on production networks containing sensitive data.

---

**Built with 🛡️ by [Qexa Technology](https://qexa.com) | Alexander Curtis**

*Empowering cybersecurity professionals through practical education and innovative security solutions*
