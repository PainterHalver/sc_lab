#!/usr/bin/env groovy

pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git branch: 'lab3', url: 'https://github.com/painterhalver/sc_lab.git'
            }
        }
        stage('Initialize Packer and validate') {
            steps {
                dir('lab3/packer') {
                    sh 'packer init .'
                    sh 'packer validate jenkins.pkr.hcl'
                }
            }
        }
        stage('Build with Packer') {
            steps {
                dir('lab3/packer') {
                    sh 'packer build jenkins.pkr.hcl'
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