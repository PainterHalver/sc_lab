#!/usr/bin/env groovy

job('HelloWorld') {
    description('A simple HelloWorld job')
    steps {
        shell('echo "Hello, World! From Jenkins Job DSL Groovy!"')
    }
}
