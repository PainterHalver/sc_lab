#!/usr/bin/env groovy

job('HelloWorld') {
    parameters {
        stringParam('AMI_ID', 'ami-111', 'The base AMI id used to patch')
    }
    authenticationToken("/usr/local/bin/aws ssm get-parameter --name /jenkins/auth_token --query Parameter.Value --output text".execute().text.trim())
    description('A simple HelloWorld job')
    steps {
        shell('echo "Hello, World! From Jenkins Job DSL Groovy!"')
    }
}
