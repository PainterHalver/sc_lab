# # resource "aws_cloudwatch_event_rule" "every_1_day" {
# #   name                = "every-1-day"
# #   description         = "Fires every 1 day"
# #   schedule_expression = "rate(1 day)"
# # }

# # resource "aws_cloudwatch_event_target" "every_1_day" {
# #   rule      = aws_cloudwatch_event_rule.every_1_day.name
# #   target_id = "lambda_ami_function"
# #   arn       = aws_lambda_function.lambda_check_ami.arn
# # }

# # resource "aws_lambda_permission" "allow_eventbridge" {
# #   statement_id  = "AllowExecutionFromEventBridge"
# #   action        = "lambda:InvokeFunction"
# #   function_name = aws_lambda_function.lambda_check_ami.function_name
# #   principal     = "events.amazonaws.com"
# #   source_arn    = aws_cloudwatch_event_rule.every_1_day.arn
# # }

# resource "aws_lambda_function" "lambda_check_ami" {
#   function_name = "function_check_ami_and_trigger_pipeline"
#   description   = "Check AMI and trigger pipeline"
#   architectures = ["x86_64"]
#   role          = aws_iam_role.iam_for_lambda.arn
#   runtime       = "python3.12"
#   environment {
#     variables = {
#       JENKINS_URL = "http://${aws_instance.ec2_jenkins.public_ip}:8080"
#     }
#   }

#   filename = "lambda.zip"
#   handler  = "lambda.lambda_handler"

#   provisioner "local-exec" {
#     command = "rm -f lambda.zip"
#   }
# }

# data "archive_file" "lambda" {
#   type        = "zip"
#   source_file = "${path.module}/misc/lambda.py"
#   output_path = "lambda.zip"
# }

# resource "aws_iam_role" "iam_for_lambda" {
#   name = "iam_for_lambda"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Action = "sts:AssumeRole",
#         Effect = "Allow",
#         Principal = {
#           Service = "lambda.amazonaws.com"
#         }
#       }
#     ]
#   })

#   inline_policy {
#     name = "AllowSSMParameterActions"
#     policy = jsonencode({
#       Version = "2012-10-17",
#       Statement = [
#         {
#           Action = [
#             "ssm:GetParameter",
#             "ssm:PutParameter"
#           ],
#           Effect   = "Allow",
#           Resource = "*"
#         }
#       ]
#     })
#   }

#   inline_policy {
#     name = "AllowCloudWatchLogs"
#     policy = jsonencode({
#       "Version" : "2012-10-17",
#       "Statement" : [
#         {
#           "Action" : [
#             "logs:CreateLogGroup",
#             "logs:CreateLogStream",
#             "logs:PutLogEvents"
#           ],
#           "Effect" : "Allow",
#           "Resource" : "*"
#         }
#       ]
#     })
#   }
# }