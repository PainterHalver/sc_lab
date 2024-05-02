#!/usr/bin/env groovy

pipeline {
    agent {
        label 'ec2-agent'
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/PainterHalver/sc_lab.git'
            }
        }
        // Get the latest git commit hash of repo sc_lab3_app, not this sc_lab repo
        stage('Get latest git commit hash') {
            steps {
                script {
                    env.GIT_COMMIT = sh(script: 'git ls-remote https://github.com/painterhalver/sc_lab3_app.git HEAD | awk \'{ print $1 }\'', returnStdout: true).trim()
                }
            }
        }
        stage('Init and validate') {
            steps {
                dir('lab3') {
                    sh 'terraform init -migrate-state'
                    sh "terraform validate"
                }
            }
        }
        stage('Plan') {
            steps {
                dir('lab3') {
                    sh "terraform plan -target=module.app -var app_git_commit_hash=${GIT_COMMIT} -out=tfplan"
                }
            }
        }
        stage('Apply') {
            steps {
                dir('lab3') {
                    sh "terraform apply -auto-approve tfplan"
                }
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}
