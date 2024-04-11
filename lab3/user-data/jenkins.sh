#!/bin/bash

set -exo pipefail

# Install dependencies
yum install -y wget git nfs-utils unzip yum-utils

# Download packer
wget https://releases.hashicorp.com/packer/1.10.2/packer_1.10.2_linux_amd64.zip
unzip packer_1.10.2_linux_amd64.zip
which -a packer | xargs rm -rf
mv packer /usr/bin/packer
hash -r
rm packer_1.10.2_linux_amd64.zip

# Install AWS CLI if not already installed:
if ! command -v aws && [ ! -f /usr/local/bin/aws ]; then
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  ./aws/install
  rm -rf awscliv2.zip aws
fi

# Install docker
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io

# Mount NFS sharecd
# mkdir -p /data
# mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport 10.0.0.89:/ /data
# chmod go+rw /data

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
Environment="CASC_JENKINS_CONFIG=/var/lib/jenkins/casc.yaml"
Environment="JAVA_OPTS=-Djava.awt.headless=true -Djenkins.install.runSetupWizard=false -Xmx512m"
EOF

# Maybe change config.xml useSecurity to false???
systemctl daemon-reload
systemctl enable jenkins
systemctl restart jenkins

# Download and install Jenkins plugins
wget -O /opt/jenkins-cli.jar http://localhost:8080/jnlpJars/jenkins-cli.jar

# Run install-plugin command, retry up to 10 times
for i in {1..10}; do
  java -jar /opt/jenkins-cli.jar -s http://localhost:8080/ install-plugin ant:latest antisamy-markup-formatter:latest build-timeout:latest cloudbees-folder:latest credentials-binding:latest email-ext:latest git:latest github-branch-source:latest gradle:latest ldap:latest mailer:latest matrix-auth:latest pam-auth:latest pipeline-github-lib:latest pipeline-stage-view:latest ssh-slaves:latest timestamper:latest workflow-aggregator:latest ws-cleanup:latest configuration-as-code:latest job-dsl:latest startup-trigger-plugin:latest ansicolor:latest build-token-root:latest sonar:latest && break
  sleep 5
done

# Create Jenkins configuration as code file
cat >> /var/lib/jenkins/casc.yaml <<EOF
credentials:
  system:
    domainCredentials:
      - credentials:
          - string:
              scope: GLOBAL
              id: "sonarqube_token"
              secret: "1144a76b7bb87021f2054c47396e4eb0b349c7fa"
              description: "SonarQube Token"
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
security:
  globalJobDslSecurityConfiguration:
    useScriptSecurity: false
unclassified:
  ansiColorBuildWrapper:
    globalColorMapName: "xterm"
  sonarGlobalConfiguration:
    buildWrapperEnabled: false
    installations:
    - credentialsId: "sonarqube_token"
      name: "SonarCloud Server"
      serverUrl: "https://sonarcloud.io"
      triggers:
        skipScmCause: false
        skipUpstreamCause: false
tool:
  mavenGlobalConfig:
    globalSettingsProvider: "standard"
    settingsProvider: "standard"
  sonarRunnerInstallation:
    installations:
    - name: "sonar-scanner"
      properties:
      - installSource:
          installers:
          - sonarRunnerInstaller:
              id: "5.0.1.3006"
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
        scm {
          git {
            branch('lab3')
            remote {
              url('https://github.com/painterhalver/sc_lab.git')
            }
            extensions {
              cloneOptions {
                depth(1)
                shallow(true)
                noTags(true)
              }
              wipeWorkspace()
            }
          }
        }
        steps {
          dsl {
            external('lab3/jenkins_jobs/HelloWorld.dsl')
            external('lab3/jenkins_jobs/BuildJenkinsAMI.dsl')
            external('lab3/jenkins_jobs/PythonAppCI.dsl')
          }
        }
        publishers {
          wsCleanup()
        }
      }
EOF

# Restart Jenkins
systemctl restart jenkins

