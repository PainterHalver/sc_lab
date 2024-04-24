resource "aws_cloudwatch_event_rule" "every_1_day" {
  name                = "every-1-day"
  description         = "Fires every 1 day"
  schedule_expression = "rate(1 day)"

  tags = var.default_tags
}

resource "aws_cloudwatch_event_target" "every_1_day" {
  rule      = aws_cloudwatch_event_rule.every_1_day.name
  target_id = "lambda_ami_function"
  arn       = aws_lambda_function.check_ami.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.check_ami.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_1_day.arn
}

# PARAMETER STORE for current hip ami
resource "aws_ssm_parameter" "current_hip_ami_id" {
  name  = "current-hip-ami-id"
  type  = "String"
  value = "ami-12345"

  tags = var.default_tags
}

resource "aws_lambda_function" "check_ami" {
  function_name = "function_check_ami_and_trigger_pipeline"
  description   = "Check AMI and trigger pipeline"
  architectures = ["x86_64"]
  role          = aws_iam_role.lambda.arn
  runtime       = "python3.12"
  environment {
    variables = {
      JENKINS_URL = "http://${aws_instance.jenkins.public_ip}:8080"
    }
  }

  filename = "lambda.zip"
  handler  = "lambda.lambda_handler"

  tags = var.default_tags
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/misc/lambda.py"
  output_path = "lambda.zip"
}

resource "aws_iam_role" "lambda" {
  name = "lambda"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  inline_policy {
    name = "AllowSSMParameterActions"
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Action = [
            "ssm:GetParameter",
            "ssm:PutParameter"
          ],
          Effect   = "Allow",
          Resource = "*"
        }
      ]
    })
  }

  inline_policy {
    name = "AllowCloudWatchLogs"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Effect" : "Allow",
          "Resource" : "*"
        }
      ]
    })
  }

  tags = var.default_tags
}
