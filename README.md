# WG-Easy Installation Automation Suite
With this repository, you can effortlessly set up and manage the WireGuard VPN.

By following the below steps, you can limit access to your application for specific IP addresses.

- [Configuration](#configuring-environment-variables)
- [Installation](#installation-steps)
- [Limiting Access using iptables](#limiting-access-to-your-application-using-iptables)
## Prerequisites

- Ensure you have Ansible installed on the control machine.
- Add your target hosts to the `inventory.ini` file, including the user and SSH key.

## Configuring Environment Variables
Before initiating the installation process, it's essential to configure the environment variables within the `install_wg.yaml` file to align with your specific setup.

1. Domain
   - **Purpose**: Specifies the domain for accessing the WG-Easy management interface.
   - **Details**: Determines the URL or address where you can access the VPN management interface.

2. Password
   - **Purpose**: Establishes a secure access credential.
   - **Details**: This password safeguards the WG-Easy management interface, ensuring that only authorized individuals have the privilege to make alterations.

3. Allowed_IPs
   - **Purpose**: Defines which IP addresses can connect.
   - **Details**: Enter the IP addresses you trust. This acts as a whitelist, enhancing security by guaranteeing that only recognized devices can access the network.

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
### Backup Current iptables Rules
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
#### If you wish to revert the changes:

1. Remove the specific rules:
```yaml
sudo iptables -D INPUT -p tcp --dport 8080 -s 18.193.103.31 -j ACCEPT
sudo iptables -D INPUT -p tcp --dport 8080 -j DROP
```
2. Or, restore from backup:
```yaml
sudo iptables-restore < ~/iptables-backup.rules
```

# Feedback and Contributions
Feedback is welcomed, issues, and pull requests! If you have any suggestions or find any bugs, please open an issue on my GitHub repository.
