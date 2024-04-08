#!/bin/bash

set -exo pipefail
yum install -y wget

##########################################
# Configure Cloudwatch agent
##########################################

# Install the CloudWatch agent
wget https://amazoncloudwatch-agent.s3.amazonaws.com/redhat/amd64/latest/amazon-cloudwatch-agent.rpm
rpm -U amazon-cloudwatch-agent.rpm
rm -rf amazon-cloudwatch-agent.rpm

# Create the CloudWatch agent configuration file
# Metrics: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Agent-Configuration-File-Details.html#CloudWatch-Agent-Configuration-File-Metricssection
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/metrics-collected-by-CloudWatch-agent.html#linux-metrics-enabled-by-CloudWatch-agent
cat <<EOF > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
{
  "metrics": {
    "metrics_collected": {
      "mem": {
        "metrics_collection_interval": 10,
        "measurement": [
          "mem_used_percent"
        ]
      },
      "disk": {
        "resources": [
          "/",
          "/boot"
        ],
        "measurement": [
          "total",
          "used_percent"
        ],
        "metrics_collection_interval": 10
      }
    }
  }
}
EOF

# Start the CloudWatch agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json

echo "Done metric!" >> /root/user-data.log
