resource "aws_cloudwatch_dashboard" "ec2_dashboard" {
  dashboard_name = "ec2-lab2-dashboard"
  dashboard_body = jsonencode({
    "widgets" : [
      {
        "height" : 6,
        "width" : 5,
        "y" : 0,
        "x" : 0,
        "type" : "metric",
        "properties" : {
          "legend" : {
            "position" : "bottom"
          },
          "liveData" : true,
          "metrics" : [
            ["CWAgent", "disk_total", "path", "/", "host", aws_instance.ec2_app.private_dns, "device", "xvda2", "fstype", "xfs"],
            [".", "disk_used_percent", ".", ".", ".", ".", ".", ".", ".", "."]
          ],
          "period" : 10,
          "region" : var.aws_region,
          "stacked" : true,
          "stat" : "Average",
          "title" : "App Disk Used Percent",
          "view" : "singleValue"
        }
      },
      {
        "height" : 6,
        "width" : 10,
        "y" : 0,
        "x" : 14,
        "type" : "metric",
        "properties" : {
          "metrics" : [
            ["CWAgent", "mem_used_percent", "host", aws_instance.ec2_app.private_dns]
          ],
          "period" : 10,
          "region" : var.aws_region,
          "stacked" : false,
          "stat" : "Average",
          "title" : "App Memory Used Percent",
          "view" : "timeSeries"
        }
      },
      {
        "height" : 6,
        "width" : 9,
        "y" : 0,
        "x" : 5,
        "type" : "metric",
        "properties" : {
          "metrics" : [
            [{ "expression" : "100 - appcpuidle", "label" : "app_cpu_usage" }],
            ["CWAgent", "cpu_usage_idle", "host", aws_instance.ec2_app.private_dns, "cpu", "cpu-total", { "id" : "appcpuidle", "visible" : false }]
          ],
          "period" : 10,
          "region" : var.aws_region,
          "stacked" : true,
          "stat" : "Average",
          "title" : "App CPU Usage",
          "view" : "timeSeries"
        }
      },
      {
        "height" : 6,
        "width" : 5,
        "y" : 6,
        "x" : 0,
        "type" : "metric",
        "properties" : {
          "legend" : {
            "position" : "bottom"
          },
          "liveData" : true,
          "metrics" : [
            ["CWAgent", "disk_total", "path", "/", "host", aws_instance.ec2_proxy.private_dns, "device", "xvda2", "fstype", "xfs"],
            [".", "disk_used_percent", ".", ".", ".", ".", ".", ".", ".", "."]
          ],
          "period" : 10,
          "region" : var.aws_region,
          "stacked" : true,
          "stat" : "Average",
          "title" : "Proxy Disk Used Percent",
          "view" : "singleValue"
        }
      },
      {
        "height" : 6,
        "width" : 5,
        "y" : 12,
        "x" : 0,
        "type" : "metric",
        "properties" : {
          "legend" : {
            "position" : "bottom"
          },
          "liveData" : true,
          "metrics" : [
            ["CWAgent", "disk_total", "path", "/", "host", module.vpc_with_nat_instance.nat_private_dns, "device", "xvda2", "fstype", "xfs"],
            [".", "disk_used_percent", ".", ".", ".", ".", ".", ".", ".", "."]
          ],
          "period" : 10,
          "region" : var.aws_region,
          "stacked" : true,
          "stat" : "Average",
          "title" : "NAT Disk Used Percent",
          "view" : "singleValue"
        }
      },
      {
        "height" : 6,
        "width" : 9,
        "y" : 6,
        "x" : 5,
        "type" : "metric",
        "properties" : {
          "metrics" : [
            [{ "expression" : "100 - proxycpuidle", "label" : "proxy_cpu_usage" }],
            ["CWAgent", "cpu_usage_idle", "host", aws_instance.ec2_proxy.private_dns, "cpu", "cpu-total", { "id" : "proxycpuidle", "visible" : false }]
          ],
          "period" : 10,
          "region" : var.aws_region,
          "stacked" : true,
          "stat" : "Average",
          "title" : "Proxy CPU Usage",
          "view" : "timeSeries"
        }
      },
      {
        "height" : 6,
        "width" : 9,
        "y" : 12,
        "x" : 5,
        "type" : "metric",
        "properties" : {
          "metrics" : [
            [{ "expression" : "100 - natcpuidle", "label" : "nat_cpu_usage" }],
            ["CWAgent", "cpu_usage_idle", "host", module.vpc_with_nat_instance.nat_private_dns, "cpu", "cpu-total", { "id" : "natcpuidle", "visible" : false }]
          ],
          "period" : 10,
          "region" : var.aws_region,
          "stacked" : true,
          "stat" : "Average",
          "title" : "NAT CPU Usage",
          "view" : "timeSeries"
        }
      },
      {
        "height" : 6,
        "width" : 10,
        "y" : 6,
        "x" : 14,
        "type" : "metric",
        "properties" : {
          "metrics" : [
            ["CWAgent", "mem_used_percent", "host", aws_instance.ec2_proxy.private_dns]
          ],
          "period" : 10,
          "region" : var.aws_region,
          "stacked" : false,
          "stat" : "Average",
          "title" : "Proxy Memory Used Percent",
          "view" : "timeSeries"
        }
      },
      {
        "height" : 6,
        "width" : 10,
        "y" : 12,
        "x" : 14,
        "type" : "metric",
        "properties" : {
          "metrics" : [
            ["CWAgent", "mem_used_percent", "host", module.vpc_with_nat_instance.nat_private_dns]
          ],
          "period" : 10,
          "region" : var.aws_region,
          "stacked" : false,
          "stat" : "Average",
          "title" : "NAT Memory Used Percent",
          "view" : "timeSeries"
        }
      }
    ]
  })
}
