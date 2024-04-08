#!/bin/bash

set -exo pipefail

# Setup the Linux AMI to be a NAT instance
# https://docs.aws.amazon.com/vpc/latest/userguide/VPC_NAT_Instance.html#create-nat-ami
yum install iptables-services -y
systemctl enable iptables
systemctl start iptables

echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.d/custom-ip-forwarding.conf
sysctl -p /etc/sysctl.d/custom-ip-forwarding.conf

# Primary network interface should be eth0
/sbin/iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
/sbin/iptables -F FORWARD

# Success log
echo "OK!" >> /root/user-data.log

