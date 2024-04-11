#!/bin/bash

set -exo pipefail

# Install common dependencies
yum install -y nano git unzip wget

# Install aws-cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
rm -rf awscliv2.zip aws

# Preinstall amazon-cloudwatch-agent
wget https://amazoncloudwatch-agent.s3.amazonaws.com/redhat/amd64/latest/amazon-cloudwatch-agent.rpm
rpm -U amazon-cloudwatch-agent.rpm
rm -rf amazon-cloudwatch-agent.rpm