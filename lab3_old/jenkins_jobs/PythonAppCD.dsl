#!/usr/bin/env groovy

pipelineJob('python-app-cd') {
    displayName('PythonAppCD')
    description('Deploy/Apply new version of the app infrastructure')
    definition {
        cps {
            script(readFileFromWorkspace('lab3/jenkins_jobs/PythonAppCD.pipeline.groovy'))
            sandbox()
        }
    }
}
