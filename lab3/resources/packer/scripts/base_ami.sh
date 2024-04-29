#!/bin/bash

set -exo pipefail

# Install common dependencies
yum clean all
yum install -y git unzip wget

# Install aws-cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
rm -rf awscliv2.zip aws

# Install docker
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io
systemctl enable docker

# Install amazon-cloudwatch-agent
wget https://amazoncloudwatch-agent.s3.amazonaws.com/redhat/amd64/latest/amazon-cloudwatch-agent.rpm
rpm -U amazon-cloudwatch-agent.rpm
rm -rf amazon-cloudwatch-agent.rpm

echo "Base AMI built at $(date)" > /opt/base.txt
