resource "aws_kms_key" "kms_ebs" {
  description = "KMS key for EBS"
  policy = jsonencode({
    Id = "example"
    Statement = [
      {
        Action = "kms:*"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }

        Resource = "*"
        Sid      = "Enable IAM User Permissions"
      },
    ]
    Version = "2012-10-17"
  })
}

resource "aws_kms_key" "kms_rds" {
  description = "KMS key for RDS"
}



