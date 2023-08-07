# WG-Easy Installation Automation

This repository contains automation scripts for installing WG-Easy using Docker Compose with Ansible. It simplifies the setup and management of the WireGuard VPN by leveraging containerization and automation.

## Prerequisites

- Ensure you have Ansible installed on the control machine.
- Add your target hosts to the `inventory.ini` file, including the user and SSH key.

### Environment Variables

You need to modify the environment variables in the `install_wg.yaml` file to match your setup:

- `domain`: The domain where WG-Easy will be accessible.
- `password`: Password for accessing the WG-Easy management interface.
- `allowed_ips`: Whitelisted IP's

## Installation Steps

### Step 1: Install Docker-Compose

Run the following command to install Docker and Docker Compose on the target hosts:

```bash
ansible-playbook -i inventory.ini install_docker.yaml
```
### Step 2: Install WG-Easy
Run the following command to install WG-Easy using Docker Compose:

```bash
ansible-playbook -i inventory.ini install_wg.yaml
```

That's it! Your WG-Easy installation should now be accessible at the domain you specified.
