#!/bin/bash

set -exo pipefail

# Create the CloudWatch agent configuration file
cat <<EOF > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/app-access.log",
            "log_group_name": "LAB-3",
            "log_stream_name": "PythonAppAccessLog - {instance_id}",
            "retention_in_days": 1
          },
          {
            "file_path": "/var/log/app-error.log",
            "log_group_name": "LAB-3",
            "log_stream_name": "PythonAppErrorLog - {instance_id}",
            "retention_in_days": 1
          },
          {
            "file_path": "/var/log/cloud-init-output.log",
            "log_group_name": "LAB-3",
            "log_stream_name": "CloudInitOutputLog - {instance_id}",
            "retention_in_days": 1
          }
        ]
      }
    }
  }
}
EOF

# Start the CloudWatch agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json

echo "App AMI built at $(date)" > /opt/app.txt