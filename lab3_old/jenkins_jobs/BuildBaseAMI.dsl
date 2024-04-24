#!/usr/bin/env groovy

pipelineJob('BuildBaseAMI') {
    parameters {
        stringParam('HIP_AMI_ID', 'ami-...', 'The HIP Base AMI ID used to build')
    }
    authenticationToken("/usr/local/bin/aws ssm get-parameter --name /jenkins/auth_token --query Parameter.Value --output text".execute().text.trim())
    description('Build a Base AMI from HIP AMI')
    definition {
        cps {
            script(readFileFromWorkspace('lab3/jenkins_jobs/BuildBaseAMI.pipeline.groovy'))
            sandbox()
        }
    }
}
