#!/usr/bin/env groovy

job('Build Jenkins AMI') {
    description('Automatically build a jenkins AMI from BASE AMI')
    scm {
        git {
            branch('lab3')
            remote {
                url('https://github.com/painterhalver/sc_lab.git')
            }
            extensions {
                cloneOptions {
                    depth(1)
                    shallow(true)
                }
            }
        }
    }
    steps {
        shell('''#!/bin/bash
set -ex

cd lab3/packer
packer init .
packer validate jenkins.pkr.hcl
packer build jenkins.pkr.hcl
echo "Done!"
        ''')
    }
    publishers {
        wsCleanup()
    }
}
