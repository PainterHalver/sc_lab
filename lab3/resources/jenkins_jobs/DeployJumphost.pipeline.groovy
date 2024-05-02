#!/usr/bin/env groovy

pipeline {
    agent {
        label 'ec2-agent'
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/painterhalver/sc_lab.git'
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
                    sh "terraform plan -target=module.jumphost -out=tfplan"
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
