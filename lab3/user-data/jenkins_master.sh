#!/bin/bash

set -exo pipefail

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
            external('lab3/jenkins_jobs/BuildBaseAMI.dsl')
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
