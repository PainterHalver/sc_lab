#!/usr/bin/env groovy

pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/PainterHalver/sc_lab.git'
                script {
                    env.GIT_COMMIT = sh(script: 'git rev-parse HEAD', returnStdout: true).trim()
                }
            }
        }
        stage('Init and validate') {
            steps {
                dir('lab3/app') {
                    sh 'terraform init -reconfigure'
                    sh "terraform validate"
                }
            }
        }
        stage('Plan') {
            steps {
                dir('lab3/app') {
                    sh "terraform plan -var app_git_commit_hash=${GIT_COMMIT} -out=tfplan"
                }
            }
        }
        stage('Apply') {
            steps {
                dir('lab3/app') {
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
