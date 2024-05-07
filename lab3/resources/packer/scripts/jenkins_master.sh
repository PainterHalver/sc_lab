#!/bin/bash

set -exo pipefail

# Install dependencies
yum install -y wget git unzip yum-utils nfs-utils make

# Enable 2GB of swap file
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile swap swap defaults 0 0' | sudo tee -a /etc/fstab

# Download packer
wget https://releases.hashicorp.com/packer/1.10.2/packer_1.10.2_linux_amd64.zip
unzip packer_1.10.2_linux_amd64.zip
which -a packer | xargs rm -rf
mv packer /usr/bin/packer
hash -r
rm packer_1.10.2_linux_amd64.zip

# Download terraform
wget https://releases.hashicorp.com/terraform/1.7.5/terraform_1.7.5_linux_amd64.zip
unzip terraform_1.7.5_linux_amd64.zip
mv terraform /usr/bin/terraform
rm terraform_1.7.5_linux_amd64.zip

# Install Jenkins
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
yum install -y fontconfig java-17-openjdk
yum install -y jenkins

# Allow Jenkins to run docker commands
usermod -aG docker jenkins

# Disable Jenkins post-installation setup wizard add JAVA_OPTS=-Djenkins.install.runSetupWizard=false
mkdir -p /usr/lib/systemd/system/jenkins.service.d
cat > /usr/lib/systemd/system/jenkins.service.d/overrides.conf <<EOF
[Service]
Environment="JAVA_OPTS=-Djava.awt.headless=true -Djenkins.install.runSetupWizard=false -Xmx512m"
EOF

systemctl daemon-reload
systemctl disable jenkins
systemctl start jenkins

# Download and install Jenkins plugins
wget -O /opt/jenkins-cli.jar http://localhost:8080/jnlpJars/jenkins-cli.jar

# Run install-plugin command, retry up to 10 times
echo "Wait a while for Jenkins to warm up..."
sleep 20
for i in {1..10}; do
  java -jar /opt/jenkins-cli.jar -s http://localhost:8080/ install-plugin ant:latest antisamy-markup-formatter:latest build-timeout:latest cloudbees-folder:latest credentials-binding:latest email-ext:latest git:latest github-branch-source:latest gradle:latest ldap:latest mailer:latest matrix-auth:latest pam-auth:latest pipeline-github-lib:latest pipeline-stage-view:latest ssh-slaves:latest timestamper:latest workflow-aggregator:latest ws-cleanup:latest configuration-as-code:latest job-dsl:latest startup-trigger-plugin:latest ansicolor:latest build-token-root:latest sonar:latest ec2:latest && break
  sleep 5
  if [ $i -eq 10 ]; then
    exit 1
  fi
done

echo "Jenkins AMI built at $(date)" > /opt/jenkins.txt
