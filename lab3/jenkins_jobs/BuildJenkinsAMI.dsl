#!/usr/bin/env groovy

pipelineJob('build-jenkins-ami') {
    displayName('Build Jenkins AMI')
    description('Automatically build a jenkins AMI from BASE AMI')
    definition {
        cps {
            script(readFileFromWorkspace('lab3/jenkins_jobs/BuildJenkinsAMI.pipeline.groovy'))
            sandbox()
        }
    }
}
