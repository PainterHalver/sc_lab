resource "aws_s3_bucket" "sc_lab3_app_bucket" {
  bucket        = "sc-lab3-app-bucket"
  force_destroy = true

  tags = var.default_tags
}
