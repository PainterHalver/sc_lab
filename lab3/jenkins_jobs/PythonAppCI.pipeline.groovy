#!/usr/bin/env groovy

pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/PainterHalver/sc_lab3_app.git'
                script {
                    env.GIT_COMMIT = sh(script: 'git rev-parse HEAD', returnStdout: true).trim()
                }
            }
        }
        stage('SonarQube analysis') {
            steps{
                script {
                    def scannerHome = tool 'sonar-scanner'
                    withSonarQubeEnv('SonarCloud Server') {
                        sh """
                        ${scannerHome}/bin/sonar-scanner \
                        -Dsonar.organization=hiep-dao \
                        -Dsonar.projectKey=hiep-dao_scl-lab3-app \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=https://sonarcloud.io
                        """
                    }
                }
            }
        }
        stage("SonarQube Quality Gate Check") {
            steps {
                script {
                    def qualityGate = waitForQualityGate()
                    if (qualityGate.status != 'OK') {
                        echo "${qualityGate.status}"
                        error "Quality Gate failed: ${qualityGateStatus}"
                    }
                    else {
                        echo "${qualityGate.status}"
                        echo "SonarQube Quality Gates Passed"
                    }
                }
            }
        }
        // stage('Docker Login') {
        //     steps {
        //         script {
        //             sh '''
        //             echo $(aws ecr-public get-login-password --region us-east-1) | \
        //                 docker login --username AWS --password-stdin public.ecr.aws/j7u4k4y6
        //             '''
        //         }
        //     }
        // }
        // stage('Build Docker Image') {
        //     steps {
        //         script {
        //             sh '''
        //             docker build -t app .
        //             '''
        //         }
        //     }
        // }
        // stage('Tag and Push Docker Image') {
        //     steps {
        //         script {
        //             sh """
        //             docker tag app:latest public.ecr.aws/j7u4k4y6/app:latest
        //             docker push public.ecr.aws/j7u4k4y6/app:latest
        //             docker tag app:latest public.ecr.aws/j7u4k4y6/app:${GIT_COMMIT}
        //             docker push public.ecr.aws/j7u4k4y6/app:${GIT_COMMIT}
        //             """
        //         }
        //     }
        // }
    }
    post {
        always {
            cleanWs()
            script {
                sh '''
                docker rmi -f $(docker images 'public.ecr.aws/j7u4k4y6/app' -q)
                '''
            }
        }
    }
}
