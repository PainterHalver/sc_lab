resource "aws_s3_bucket" "app" {
  bucket        = "sc-lab3-app-bucket"
  force_destroy = true

  tags = var.default_tags
}

resource "aws_kms_key" "app" {
  description  = "KMS key for S3 App bucket"
  multi_region = false

  tags = var.default_tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "app" {
  bucket = aws_s3_bucket.app.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.app.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
