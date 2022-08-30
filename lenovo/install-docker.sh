#! /bin/bash

# Update the apt package index and install packages to allow apt to use a repository over HTTPS
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release
# Helpers
sudo apt install -y cat grep cut

# Add Docker’s official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up the repository
DISTRO_RELEASE
cat /etc/os-release | grep 'NAME="Linux Mint"' >/dev/null 2>&1
if [["$?" == "0"]]; then
    DISTRO_RELEASE=$(cat /etc/os-release | grep -i "UBUNTU_CODENAME" | cut -d '=' -f 2)
else
    DISTRO_RELEASE=$(lsb_release
fi
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $DISTRO_RELEASE -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the apt package index, and install the latest version of Docker Engine, containerd, and Docker Compose
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Post installation setup

# Create the docker group.
sudo groupadd docker

# Add your user to the docker group.
sudo usermod -aG docker $USER

echo "--> 1. Logout and logback in to your system (you might have to restart)"
echo "--> 2. After logging back into your system run the following command to test docker"
echo 
echo "       docker run hello-world"