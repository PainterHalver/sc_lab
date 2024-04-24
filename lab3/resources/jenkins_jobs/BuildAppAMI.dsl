#!/usr/bin/env groovy

pipelineJob('BuildAppAMI') {
    description('Build an App AMI from Base AMI')
    // Run this job if the BuildBaseAMI job is successful
    triggers{
        upstream('BuildBaseAMI', 'SUCCESS')
    }
    definition {
        cps {
            script(readFileFromWorkspace('lab3/resources/jenkins_jobs/BuildAppAMI.pipeline.groovy'))
            sandbox()
        }
    }
}
