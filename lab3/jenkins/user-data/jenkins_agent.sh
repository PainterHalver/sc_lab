#!/bin/bash

set -exo pipefail

# Install common dependencies
yum clean all
yum install -y nano git unzip wget java-17-openjdk

# Install aws-cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
rm -rf awscliv2.zip aws

# Download packer
wget https://releases.hashicorp.com/packer/1.10.2/packer_1.10.2_linux_amd64.zip
unzip packer_1.10.2_linux_amd64.zip
which -a packer | xargs rm -rf
mv packer /usr/bin/packer
hash -r
rm packer_1.10.2_linux_amd64.zip

# Install docker
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io
usermod -aG docker ec2-user
systemctl start docker

# Add public key for terraform
mkdir -p /home/ec2-user/.ssh
cat > /home/ec2-user/.ssh/id_rsa.pub <<EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCcjv0B6NjewjBZszn1fatY+UNcB7Ln4g2s3R+NoMH6Y+eprLSXlIyZaFnYh3b/pejPPz9g5YyYI6f+3Q5YCQ9FhSgkxwP0H22zOcKhqAfZW9RoVOtHBS5Pe7DCxtzlNRpmkdQtDkJ5ooWnfHAsofN140YZXSEHJqwo+xOqPzsHen/cm98Fmx3QSbcdqIobahF/WiuiYv45RpgORnEQKxlhz/Wb2TGsMGVtNbcIZYG2UPARKywYpbrbgezoJSKrkc3elHQ7NJahwLlppuT9f6ZxQxstBq5itFgydgnAzL/fCT3M3nA6hDH6fnzWGcGKHuHPue2reFVgw0UswktzLQp5NBuwa7G1lH+PyHImLX1B/yiRflF5YZudrmOACyxExhgXBFrY60waCi7q2xaCtmqL/YCYVkH7pDtjcTTHiMp0UXWq5/j7Yv5J67UpDGzrUb16Sb1Fja5bdnjrJrq64r3QJSJxVy+974v0U5fR90iamCA9vmYaY7DV66ILd/OSBmk= root@ldap-server-instance
EOF