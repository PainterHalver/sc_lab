#!/bin/bash

set -exo pipefail

# Install dependencies
sudo yum install -y wget

# Install Jenkins
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
yum install -y fontconfig java-17-openjdk
yum install -y jenkins

# Disable Jenkins post-installation setup wizard add JAVA_OPTS=-Djenkins.install.runSetupWizard=false
mkdir -p /usr/lib/systemd/system/jenkins.service.d
cat > /usr/lib/systemd/system/jenkins.service.d/overrides.conf <<EOF
[Service]
Environment="CASC_JENKINS_CONFIG=/var/lib/jenkins/casc.yaml"
Environment="JAVA_OPTS=-Djava.awt.headless=true -Djenkins.install.runSetupWizard=false"
EOF

# Maybe change config.xml useSecurity to false???
systemctl daemon-reload
systemctl enable jenkins
systemctl restart jenkins

# Download and install Jenkins plugins
wget -O /opt/jenkins-cli.jar http://localhost:8080/jnlpJars/jenkins-cli.jar

# Run install-plugin command, retry up to 10 times
for i in {1..10}; do
  java -jar /opt/jenkins-cli.jar -s http://localhost:8080/ install-plugin ant:latest antisamy-markup-formatter:latest build-timeout:latest cloudbees-folder:latest credentials-binding:latest email-ext:latest git:latest github-branch-source:latest gradle:latest ldap:latest mailer:latest matrix-auth:latest pam-auth:latest pipeline-github-lib:latest pipeline-stage-view:latest ssh-slaves:latest timestamper:latest workflow-aggregator:latest ws-cleanup:latest configuration-as-code:latest job-dsl:latest startup-trigger-plugin:latest && break
  sleep 5
done

# Create Jenkins configuration as code file
cat >> /var/lib/jenkins/casc.yaml <<EOF
jenkins:
  systemMessage: "Jenkins configured automatically by Jenkins Configuration as Code plugin"
  securityRealm:
    local:
      allowsSignup: false
      users:
        - id: "admin"
          name: "admin"
          password: "admin123"
  authorizationStrategy:
    loggedInUsersCanDoAnything:
      allowAnonymousRead: false
jobs:
  - script: >
      job('bootstrap') {
        description('Bootstrap job created with Jenkins Configuration as Code + Job DSL')
        triggers {
          hudsonStartupTrigger {
            quietPeriod("20")
            runOnChoice("ON_CONNECT")
            label("")
            nodeParameterName("")
          }
        }
        steps {
          dsl {
            text("""
              job('Hello World') {
                description('Hello World job created with Job DSL')
                steps {
                  shell('echo Hello, World! FROM JOB DSL')
                }
              }
            """)
          }
        }
      }
EOF

# Restart Jenkins
systemctl restart jenkins

