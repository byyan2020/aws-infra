resource "random_uuid" "bucket_suffix" {
}

resource "aws_s3_bucket_acl" "s3_webapp_acl" {
  bucket = aws_s3_bucket.s3_webapp.id
  acl    = "private"
}

resource "aws_s3_bucket" "s3_webapp" {
  bucket = "bucket-for-webapp-${random_uuid.bucket_suffix.result}"

  force_destroy = true

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
      bucket_key_enabled = true
    }
  }

  lifecycle_rule {
    id      = "move-to-ia"
    enabled = true

    prefix = "move-to-ia/"

    tags = {
      rule      = "move-to-ia"
      autoclean = "true"
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }
}
