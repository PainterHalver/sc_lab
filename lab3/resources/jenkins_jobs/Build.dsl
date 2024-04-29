#!/usr/bin/env groovy

folder('Build') {
    description('Build AMIs')
}

pipelineJob('Build/BuildBaseAMI') {
    parameters {
        stringParam('HIP_AMI_ID', 'ami-...', 'The HIP Base AMI ID used to build')
    }
    authenticationToken("/usr/local/bin/aws ssm get-parameter --name /jenkins/auth_token --query Parameter.Value --output text".execute().text.trim())
    description('Build a Base AMI from HIP AMI')
    definition {
        cps {
            script(readFileFromWorkspace('lab3/resources/jenkins_jobs/BuildBaseAMI.pipeline.groovy'))
            sandbox()
        }
    }
}

pipelineJob('Build/BuildAppAMI') {
    description('Build an App AMI from Base AMI')
    // Run this job if the BuildBaseAMI job is successful
    triggers{
        upstream('Build/BuildBaseAMI', 'SUCCESS')
    }
    definition {
        cps {
            script(readFileFromWorkspace('lab3/resources/jenkins_jobs/BuildAppAMI.pipeline.groovy'))
            sandbox()
        }
    }
}