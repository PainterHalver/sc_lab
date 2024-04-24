#!/usr/bin/env groovy

pipelineJob('python-app-ci') {
    displayName('PythonAppCI')
    description('Run CI everytime a commit is pushed to the App repo')
    properties {
        githubProjectUrl("https://github.com/PainterHalver/sc_lab3_app")
        disableConcurrentBuilds {
            abortPrevious(false)
        }
    }
    triggers {
        // Every 3 hours
        scm('H H/3 * * *')
    }
    definition {
        cps {
            script(readFileFromWorkspace('lab3/resources/jenkins_jobs/PythonAppCI.pipeline.groovy'))
            sandbox()
        }
    }
}
