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

```yaml
ansible-playbook -i inventory.ini install_docker.yaml
```
### Step 2: Install WG-Easy
Run the following command to install WG-Easy using Docker Compose:

```yaml
ansible-playbook -i inventory.ini install_wg.yaml
```

That's it! Your WG-Easy installation should now be accessible at the domain you specified.

## Limiting Access to Your Application using iptables
Backup Current iptables Rules

Before making changes, it's a good idea to backup your current iptables rules:
```yaml
sudo iptables-save > ~/iptables-backup.rules
```
1. Allow Specific IP Address
To allow access only from your WG-Easy machine to access your application running on port 443, run:
```yaml
sudo iptables -A INPUT -p tcp --dport 443 -s <wg-easy-ipv4> -j ACCEPT
```
2. Block All Other IPs
After allowing the specific IP, block all other IPs from accessing the port:
 ```yaml
 sudo iptables -A INPUT -p tcp --dport 443 -j DROP
 ```
3. List Rules
To list the iptables rules to verify:
```yaml
sudo iptables -L -n -v
```
4. Save Rules
The rules set with iptables are ephemeral, meaning they will be lost after a system reboot. To save the rules permanently:
```yaml
sudo apt-get install iptables-persistent
sudo netfilter-persistent save
```
If you wish to revert the changes:

1. Remove the specific rules:
```yaml
sudo iptables -D INPUT -p tcp --dport 8080 -s 18.193.103.31 -j ACCEPT
sudo iptables -D INPUT -p tcp --dport 8080 -j DROP
```
2. Or, restore from backup:
```yaml
sudo iptables-restore < ~/iptables-backup.rules
```
Conclusion :

By following the above steps, you can limit access to your application to specific IP addresses. Ensure you monitor your application and server after making changes, and always make backups before making any significant modifications.
