#!/bin/sh

sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt-cache policy docker-ce
sudo apt install docker-ce -y
sudo usermod -aG docker ubuntu
sudo bash -c "$(curl -sL https://get-clab.srlinux.dev)"
sudo apt-get update && sudo apt-get install -y git