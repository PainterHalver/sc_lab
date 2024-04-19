resource "aws_autoscaling_group" "app_asg" {
  name                      = "app-auto-scaling-group"
  desired_capacity          = 1
  min_size                  = 1
  max_size                  = 2
  vpc_zone_identifier       = [module.vpc_with_nat_instance.private_subnet_id]    # Use this instead of availability_zones
  target_group_arns         = [aws_lb_target_group.ec2_app_http_target_group.arn] # Use this, load_balancers is for CLB
  health_check_grace_period = 60

  launch_template {
    id      = aws_launch_template.app.id
    version = aws_launch_template.app.latest_version
  }

  instance_refresh {
    strategy = "Rolling"
    # triggers = [ "tag" ]
  }
}

resource "aws_launch_template" "app" {
  name                                 = "app-launch-template"
  description                          = "Launch template for the app EC2 instances"
  image_id                             = data.aws_ami.auto_scaling_group_ami.id
  instance_type                        = var.instance_type
  key_name                             = aws_key_pair.ssh_pubkey.key_name
  instance_initiated_shutdown_behavior = "terminate"

  user_data = base64encode(templatefile("${path.module}/user-data/app.sh.tftpl", {
    db_uri      = "mysql+pymysql://${aws_db_instance.app_database.username}:${aws_db_instance.app_database.password}@${aws_db_instance.app_database.endpoint}/${aws_db_instance.app_database.db_name}",
    bucket_name = aws_s3_bucket.sc_lab3_app_bucket.bucket
  }))

  iam_instance_profile {
    arn = module.app_instance_profile.profile_arn
  }

  network_interfaces {
    delete_on_termination = true
    device_index          = 0
    security_groups       = [aws_security_group.app_sg.id]
    subnet_id             = module.vpc_with_nat_instance.private_subnet_id
  }

  tag_specifications {
    resource_type = "instance"
    tags = merge(var.default_tags, {
      Name = "asg-app-instance"
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

module "app_instance_profile" {
  source = "../../modules/ec2_profile"

  aws_region   = var.aws_region
  default_tags = var.default_tags

  profile_name     = "PythonAppProfile"
  role_name        = "ProfileAppRole"
  role_description = "Role for EC2 Python App"

  inline_policies = [
    {
      name   = "AppS3BucketObjectAccess"
      effect = "Allow"
      action = [
        "s3:*",
      ],
      resource = "${aws_s3_bucket.sc_lab3_app_bucket.arn}/*"
    },
    {
      name   = "AppS3BucketAccess"
      effect = "Allow"
      action = [
        "s3:*",
      ],
      resource = "${aws_s3_bucket.sc_lab3_app_bucket.arn}"
    },
    {
      name   = "ConfigReadOnlyAccessPolicy"
      effect = "Allow"
      action = [
        "config:Get*",
        "config:Describe*",
        "config:Deliver*",
        "config:List*",
        "config:Select*",
        "tag:GetResources",
        "tag:GetTagKeys",
        "cloudtrail:DescribeTrails",
        "cloudtrail:GetTrailStatus",
        "cloudtrail:LookupEvents"
      ],
      resource = "*"
    }
  ]

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
  ]
}

resource "aws_security_group" "app_sg" {
  name        = "app-sg"
  description = "Security group for the app EC2 instances"
  vpc_id      = module.vpc_with_nat_instance.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] // TODO: Use load balancer's Security Group
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [module.vpc_with_nat_instance.sg_nat_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.default_tags
}
