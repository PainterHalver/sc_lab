resource "aws_s3_bucket" "app" {
  bucket        = "sc-lab3-app-bucket"
  force_destroy = true

  tags = var.default_tags
}
