#!/usr/bin/env groovy

folder('Build') {
    description('Build AMIs')
}

pipelineJob('Build/BuildBaseAMI') {
    parameters {
        stringParam('HIP_AMI_ID', 'ami-07dc7fbc73bffbeb5', 'The HIP Base AMI ID used to build')
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

pipelineJob('Build/BuildJumphostAMI') {
    description('Build Jumphost AMI from Base AMI')
    // Run this job if the BuildBaseAMI job is successful
    triggers{
        upstream('Build/BuildBaseAMI', 'SUCCESS')
    }
    definition {
        cps {
            script(readFileFromWorkspace('lab3/resources/jenkins_jobs/BuildJumphostAMI.pipeline.groovy'))
            sandbox()
        }
    }
}

pipelineJob('Build/BuildJenkinsAMI') {
    description('Build Jenkins AMI from Base AMI')
    // Run this job if the BuildBaseAMI job is successful
    triggers{
        upstream('Build/BuildBaseAMI', 'SUCCESS')
    }
    definition {
        cps {
            script(readFileFromWorkspace('lab3/resources/jenkins_jobs/BuildJenkinsAMI.pipeline.groovy'))
            sandbox()
        }
    }
}