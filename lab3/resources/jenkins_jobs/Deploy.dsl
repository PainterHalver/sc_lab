#!/usr/bin/env groovy

folder('Deploy') {
    description('Deploy AMIs')
}

pipelineJob('Deploy/DeployJumphost') {
    description('Deploy/Patch jumphost server')
    definition {
        cps {
            script(readFileFromWorkspace('lab3/resources/jenkins_jobs/DeployJumphost.pipeline.groovy'))
            sandbox()
        }
    }
}

pipelineJob('Deploy/DeployJenkinsMaster') {
    description('Deploy/Patch Jenkins master server')
    definition {
        cps {
            script(readFileFromWorkspace('lab3/resources/jenkins_jobs/DeployJenkinsMaster.pipeline.groovy'))
            sandbox()
        }
    }
}