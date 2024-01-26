# Automated WireGuard VPN Setup with Ansible and Docker

This repository provides an automated solution for setting up and managing a WireGuard VPN using Ansible, Docker, and WG-Easy. It simplifies the process of deploying a secure and efficient VPN server.

## Installation
To install and configure your WireGuard VPN, execute the following command:
```
wget https://raw.githubusercontent.com/awakzdev/wireguard-ansible/main/bootstrap.sh -O bootstrap.sh && sudo bash bootstrap.sh
```

## Table of Contents
- [Configuration](#configuration)
- [Limiting Access](#limiting-access)
- [Feedback and Contributions](#feedback-and-contributions)

This script performs the following tasks:
1. Checks for root privileges.
2. Detects the operating system.
3. Installs necessary dependencies like Ansible, Git, and Curl.
4. Clones the necessary Ansible playbooks from the repository.
5. Installs Docker and Docker Compose.
6. Sets up WireGuard with a user-friendly interface (WG-Easy).

## Configuration
The installation process will prompt you to enter specific configurations such as:
- **Domain Name**: The domain for your VPN server.
- **WireGuard UI Password**: A password to protect your WG-Easy interface.

## Limiting Access
To enhance the security of your WireGuard VPN, you may limit access using IPTables. Refer to the `iptables` instructions within the repository for more details.

## Feedback and Contributions
Your feedback and contributions are welcome! If you encounter any issues or have suggestions for improvements, please open an issue or submit a pull request on this GitHub repository.

---

## Additional Information
- **Ansible Playbooks**: 
  - `install_docker.yaml`: Installs Docker and Docker Compose.
  - `install_wg.yaml`: Installs and configures WireGuard with WG-Easy.
- **WG-Easy**: A simple, web-based management interface for WireGuard VPN.

---

For more detailed instructions and explanations, please refer to the comments within each script and playbook in this repository.
