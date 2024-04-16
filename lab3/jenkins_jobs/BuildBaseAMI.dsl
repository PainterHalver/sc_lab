#!/usr/bin/env groovy

pipelineJob('BuildBaseAMI') {
    description('Build a jenkins AMI from HIP AMI')
    definition {
        cps {
            script(readFileFromWorkspace('lab3/jenkins_jobs/BuildBaseAMI.pipeline.groovy'))
            sandbox()
        }
    }
}
