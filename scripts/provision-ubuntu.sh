#!/bin/sh

# Basic tooling
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y

# Patch PATH in bash
export PATH="${PATH}:/home/ubuntu/.local/bin" >> ~/.bashrc

# Install docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt-cache policy docker-ce
sudo apt install docker-ce -y
sudo usermod -aG docker ubuntu

# Install Containerlab
sudo bash -c "$(curl -sL https://get-clab.srlinux.dev)"

# Fix for large topology in Containerlab for cEOS
sudo sh -c 'echo "fs.inotify.max_user_instances = 50000" > /etc/sysctl.d/99-zceos.conf'
sudo sysctl -w fs.inotify.max_user_instances=50000

# Basic tooling
sudo apt install  -y git make zsh python3-pip

# Python packages
pip install eos-downloader
