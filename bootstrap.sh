#!/bin/bash -e

# Define the repository URL
REPO_URL="https://github.com/awakzdev/wireguard-ansible"

# Define playbook names
DOCKER_PLAYBOOK="install_docker.yaml"
WG_PLAYBOOK="install_wg.yaml"

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root. Please run with sudo."
    exit 1
fi

# Function to detect OS and version
detect_os() {
    if grep -qs "ubuntu" /etc/os-release; then
        OS="ubuntu"
        VER=$(grep 'VERSION_ID' /etc/os-release | cut -d '"' -f 2 | tr -d '.')
    elif [[ -e /etc/debian_version ]]; then
        OS="debian"
        VER=$(grep -oE '[0-9]+' /etc/debian_version | head -1)
    elif [[ -e /etc/centos-release || -e /etc/redhat-release ]]; then
        OS="centos"
        VER=$(grep -shoE '[0-9]+' /etc/centos-release /etc/redhat-release | head -1)
    else
        echo "Unsupported OS"
        exit 1
    fi
}

# Install dependencies based on OS
install_dependencies() {
    echo "Installing dependencies for $OS"
    case $OS in
        ubuntu|debian)
            apt-get update
            apt-get install -y ansible git curl
            ;;
        centos)
            yum update -y
            yum install -y epel-release
            yum install -y ansible git curl
            ;;
        *)
            echo "Unsupported OS for dependency installation"
            exit 1
            ;;
    esac
}

# Function to ask for domain and check A record
ask_domain_and_check_ip() {
    echo -e "\n========================================"
    echo -e "Domain Configuration Required"
    echo -e "========================================\n"
    echo "Please enter the domain you wish to configure. This should be a domain that you own and have control over its DNS settings."
    echo -e "Press Enter to continue...\n"
    read -p "Enter your domain: " domain

    # Introduce a slight delay for better readability
    sleep 1

    public_ip=$(curl -s ifconfig.me)
    echo -e "\nYour public IP address is: $public_ip"
    echo "Have you set up an A record for $domain to point to this IP address? (yes/no) : "
    read answer
    if [[ "$answer" != "yes" ]]; then
        echo -e "\nPlease set up an A record for $domain to point to $public_ip and run the script again."
        exit 1
    fi
}


# Clone the Ansible playbook repository
clone_repo() {
    if [ -d "ansible-playbooks" ]; then
        echo "Updating existing repository..."
        cd ansible-playbooks
        git pull
        cd ..
    else
        echo "Cloning the playbook repository..."
        git clone "${REPO_URL}" ansible-playbooks
    fi
}

# Run the Docker installation playbook
install_docker() {
    echo "Running the Docker installation playbook..."
    cd ansible-playbooks
    ansible-playbook -i inventory.ini "${DOCKER_PLAYBOOK}"
}

# Run the WireGuard installation playbook
install_wireguard() {
    echo "Running the WireGuard installation playbook..."
    ansible-playbook -i inventory.ini "${WG_PLAYBOOK}" --extra-vars "domain=$domain" 
}

# Main execution flow
detect_os
install_dependencies
ask_domain_and_check_ip
clone_repo
install_docker
install_wireguard

echo "Docker and WireGuard installation completed."
