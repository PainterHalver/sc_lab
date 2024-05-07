#!/bin/bash

set -exo pipefail

# Install tools
yum install -y traceroute nmap tcpdump bind-utils nano nfs-utils mysql

echo "Jumphost AMI built at $(date)" > /opt/jumphost.txt