#!/usr/bin/env groovy

pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/painterhalver/sc_lab.git'
            }
        }
        stage('Initialize Packer and validate') {
            steps {
                dir('lab3/resources/packer') {
                    sh 'packer init base_ami.pkr.hcl'
                    sh "packer validate -var 'hip_ami_id=${HIP_AMI_ID}' base_ami.pkr.hcl"
                }
            }
        }
        stage('Build with Packer') {
            steps {
                dir('lab3/resources/packer') {
                    sh "packer build -var 'hip_ami_id=${HIP_AMI_ID}' base_ami.pkr.hcl"
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
