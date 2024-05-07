resource "aws_key_pair" "app" {
  key_name   = "ssh-pubkey-app"
  public_key = file(var.ssh_pubkey_path)

  tags = var.default_tags
}

resource "aws_autoscaling_group" "app" {
  name                      = "app-auto-scaling-group"
  desired_capacity          = 2
  min_size                  = 1
  max_size                  = 3
  vpc_zone_identifier       = [var.private_subnet_id]                # Use this instead of availability_zones
  target_group_arns         = [aws_lb_target_group.ec2_app_http.arn] # Use this, load_balancers is for CLB
  health_check_grace_period = 150                                    // Wait for 150 seconds before health-check, for user-data to complete
  health_check_type         = "ELB"                                  // Use ALB target group HTTP health check 

  launch_template {
    id      = aws_launch_template.app.id
    version = aws_launch_template.app.latest_version
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50 // 50% of instances must remain healthy
    }
  }
}

resource "aws_launch_template" "app" {
  name                                 = "app-launch-template"
  description                          = "Launch template for the app EC2 instances"
  image_id                             = data.aws_ami.app.id
  instance_type                        = var.instance_type
  key_name                             = aws_key_pair.app.key_name
  instance_initiated_shutdown_behavior = "terminate"

  user_data = base64encode(templatefile("${path.module}/user-data/app.sh.tftpl", {
    db_user     = var.db_admin_user,
    db_uri      = "${aws_route53_record.rds.name}:3306/${aws_db_instance.app.db_name}",
    bucket_name = aws_s3_bucket.app.bucket
  }))

  iam_instance_profile {
    arn = module.app_instance_profile.profile_arn
  }

  network_interfaces {
    delete_on_termination = true
    device_index          = 0
    security_groups       = [aws_security_group.app.id]
    subnet_id             = var.private_subnet_id
  }

  tag_specifications {
    resource_type = "instance"
    tags = merge(var.default_tags, {
      Name       = "asg-app-instance"
      CommitHash = var.app_git_commit_hash
    })
  }

  # block_device_mappings {
  #   device_name =
  #   ebs {
  #     volume_size           = 10
  #     delete_on_termination = true
  #   }
  # }

  tags = var.default_tags
}

resource "aws_autoscaling_policy" "app" {
  name                   = "50-percent-scale-out"
  autoscaling_group_name = aws_autoscaling_group.app.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value     = 50.0
    disable_scale_in = true // Do not scale in
  }
}

module "app_instance_profile" {
  source       = "../../modules/ec2_profile"
  default_tags = var.default_tags

  profile_name     = "PythonAppProfile"
  role_name        = "ProfileAppRole"
  role_description = "Role for EC2 Python App"

  inline_policies = [
    {
      name     = "CloudWatchAgentPutLogsRetentionInlinePolicy"
      action   = ["logs:PutRetentionPolicy"]
      effect   = "Allow"
      resource = "arn:aws:logs:*:*:log-group:LAB-2:*"
    },
    {
      name   = "AppS3BucketObjectAccess"
      effect = "Allow"
      action = [
        "s3:*",
      ],
      resource = "${aws_s3_bucket.app.arn}/*"
    },
    {
      name   = "AppS3BucketAccess"
      effect = "Allow"
      action = [
        "s3:*",
      ],
      resource = "${aws_s3_bucket.app.arn}"
    },
    {
      name   = "ReadSSMParameterPolicy"
      effect = "Allow"
      action = [
        "ssm:GetParameter",
      ],
      resource = "*"
    },
    {
      name   = "KMSFullPolicy"
      effect = "Allow"
      action = [
        "kms:*",
      ],
      resource = "*"
    }
  ]

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonRDSReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  ]
}

resource "aws_security_group" "app" {
  name        = "app-sg"
  description = "Security group for the app EC2 instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.default_tags
}
