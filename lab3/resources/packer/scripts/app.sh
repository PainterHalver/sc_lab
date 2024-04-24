#!/bin/bash

set -exo pipefail

yum install -y git unzip

# Install docker if not already installed
if ! command -v docker; then
  sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  sudo yum install -y docker-ce docker-ce-cli containerd.io
  systemctl enable docker --now
fi

echo "OK!" > /root/done.txt