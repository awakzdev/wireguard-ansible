# 🛡 Automated WireGuard installation
Set up and manage WireGuard VPN.

# 📑 Table of Contents
- [Configuration](#configuration)
- [Installation](#installation-steps)
- [Limiting access using IPTables](#iptables)
## Prerequisites
- 🔑 Ansible: Ensure it's installed on your control machine.
- 📊 Inventory: Update inventory.ini with target hosts, user, and SSH key details.
- 🌐 DNS Record: Create an A type record linking your IP to the domain field 
## Ansible and Dependencies Setup

1. **⬆️ Upgrade Ansible**:
   To ensure compatibility and smooth installation, upgrade Ansible to the latest version using `pip`:
   ```
   pip3 install --upgrade ansible
   ```

2. **📦 Install Dependencies** from `requirements.yml`:
   ```
   ansible-galaxy install -r requirements.yml
   ```
<a name="configuration"></a>
## 🎛 Configuring Environment Variables
Customize 'install_wg.yaml' with your specific settings.
1. 🌍 Domain: Sets the domain for the WG-Easy management interface.
2. 🔐 Password: Secures the management interface access.
3. 📡 Allowed_IPs: List trusted IP addresses for enhanced security.

## Installation Steps
### Step 1: Install Docker-Compose 🐳
Run the following command to install Docker and Docker Compose on the target hosts:
```yaml
ansible-playbook -i inventory.ini install_docker.yaml
```
### Step 2: Install WG-Easy 🌐
Run the following command to install WG-Easy using Docker Compose:
```yaml
ansible-playbook -i inventory.ini install_wg.yaml
```
That's it! Your WG-Easy installation should now be accessible under the domain variable you specified.
<a name="iptables"></a>
## 🔒 Limiting Access to Your Application using iptables
### Backup Current iptables Rules 🗄️
Save your current rules:
```yaml
sudo iptables-save > ~/iptables-backup.rules
```
1. Allow Specific IP Address
Permit access from your WG-Easy machine:
```yaml
sudo iptables -A INPUT -p tcp --dport 443 -s <wg-easy-ipv4> -j ACCEPT
```
2. Block All Other IPs
Restrict all other IPs:
 ```yaml
 sudo iptables -A INPUT -p tcp --dport 443 -j DROP
 ```
3. List Rules
List and Verify Rules:
```yaml
sudo iptables -L -n -v
```
4. Save Rules
By default IPTables ruls are ephemeral, meaning they will be lost after a system reboot. To save the rules permanently:
```yaml
sudo apt-get install iptables-persistent
sudo netfilter-persistent save
```
#### Reverting Changes:

1. Remove Specific Rules:
```yaml
sudo iptables -D INPUT -p tcp --dport 8080 -s 18.193.103.31 -j ACCEPT
sudo iptables -D INPUT -p tcp --dport 8080 -j DROP
```
2. Restore from Backup::
```yaml
sudo iptables-restore < ~/iptables-backup.rules
```

# Feedback and Contributions
Feedback is welcomed, issues, and pull requests! If you have any suggestions or find any bugs, please open an issue on my GitHub repository.
