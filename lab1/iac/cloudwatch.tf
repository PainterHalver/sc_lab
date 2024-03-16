resource "aws_cloudwatch_dashboard" "ec2_app_dashboard" {
  dashboard_name = "ec2-app-dashboard"
  dashboard_body = jsonencode({
    "widgets": [
        {
            "type": "metric",
            "x": 0,
            "y": 0,
            "width": 5,
            "height": 6,
            "properties": {
                "metrics": [
                    [
                      "CWAgent",
                      "disk_used_percent",
                      "host",
                      aws_instance.ec2_app.private_dns,
                      "device", "xvda4", "fstype", "xfs", { "region": var.aws_region }
                    ],
                    [ ".", "disk_used_percent", ".", ".", ".", ".", ".", ".", ".", ".", { "region": var.aws_region } ]
                ],
                "view": "singleValue",
                "region": var.aws_region,
                "stat": "Average",
                "period": 10,
                "liveData": true,
                "stacked": true,
                "legend": {
                    "position": "bottom"
                },
                "title": "Disk Used Percent"
            }
        },
        {
            "type": "metric",
            "x": 14,
            "y": 0,
            "width": 10,
            "height": 6,
            "properties": {
                "metrics": [
                    [
                      "CWAgent",
                      "mem_used_percent",
                      "host",
                      aws_instance.ec2_app.private_dns
                    ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": var.aws_region,
                "stat": "Average",
                "period": 10,
                "title": "Memory Used Percent"
            }
        },
        {
            "type": "metric",
            "x": 5,
            "y": 0,
            "width": 9,
            "height": 6,
            "properties": {
                "metrics": [
                    [ "CWAgent", "cpu_usage_system", "host", aws_instance.ec2_app.private_dns, "cpu", "cpu-total", { "region": var.aws_region } ],
                    [ ".", "cpu_usage_user", ".", ".", ".", ".", { "region": var.aws_region } ],
                    [ ".", "cpu_usage_idle", ".", ".", ".", ".", { "region": var.aws_region } ],
                    [ ".", "cpu_usage_iowait", ".", ".", ".", ".", { "region": var.aws_region } ]
                ],
                "view": "timeSeries",
                "stacked": true,
                "region": var.aws_region,
                "stat": "Average",
                "period": 10,
                "title": "CPU Usage"
            }
        }
    ]
})
}
