#!/usr/bin/env groovy

folder('PythonApp') {
    description('Python App CI/CD')
}

pipelineJob('PythonApp/python-app-ci') {
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

pipelineJob('PythonApp/python-app-cd') {
    displayName('PythonAppCD')
    description('Deploy/Apply new version of the app infrastructure')
    definition {
        cps {
            script(readFileFromWorkspace('lab3/resources/jenkins_jobs/PythonAppCD.pipeline.groovy'))
            sandbox()
        }
    }
}
