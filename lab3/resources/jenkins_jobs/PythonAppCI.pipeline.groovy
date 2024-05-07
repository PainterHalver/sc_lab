#!/usr/bin/env groovy

pipeline {
    agent {
        label 'ec2-agent'
    }
    environment {
        DOCKER_IMAGE = 'app'
        DOCKER_REPO = 'public.ecr.aws/j7u4k4y6'
    }
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
                        sh "${scannerHome}/bin/sonar-scanner"
                    }
                }
            }
        }
        stage("SonarQube Quality Gate Check") {
            steps {
                script {
                    retry(5) {
                        timeout(time: 20, unit: 'SECONDS') {
                            def qualityGate = waitForQualityGate()
                            if (qualityGate.status != 'OK') {
                                echo "${qualityGate.status}"
                                error "Quality Gate failed: ${qualityGate.status}"
                            }
                            else {
                                echo "${qualityGate.status}"
                                echo "SonarQube Quality Gates Passed"
                            }
                        }
                    }
                }
            }
        }
        stage('Docker Login') {
            steps {
                script {
                    sh """
                    echo $(aws ecr-public get-login-password --region us-east-1) | \
                        docker login --username AWS --password-stdin $DOCKER_REPO
                    """
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    sh """
                    docker build -t $DOCKER_IMAGE .
                    """
                }
            }
        }
        stage('Tag and Push Docker Image') {
            steps {
                script {
                    sh """
                    docker tag $DOCKER_IMAGE:latest $DOCKER_REPO/$DOCKER_IMAGE:latest
                    docker push $DOCKER_REPO/$DOCKER_IMAGE:latest
                    docker tag $DOCKER_IMAGE:latest $DOCKER_REPO/$DOCKER_IMAGE:$GIT_COMMIT
                    docker push $DOCKER_REPO/$DOCKER_IMAGE:$GIT_COMMIT
                    """
                }
            }
        }
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
