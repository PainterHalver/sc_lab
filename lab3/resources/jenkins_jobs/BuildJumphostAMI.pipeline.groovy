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
        stage('Initialize Packer and validate') {
            steps {
                dir('lab3/resources/packer') {
                    sh 'packer init jumphost.pkr.hcl'
                    sh "packer validate jumphost.pkr.hcl"
                }
            }
        }
        stage('Build with Packer') {
            steps {
                dir('lab3/resources/packer') {
                    sh "packer build jumphost.pkr.hcl"
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
