resource "aws_iam_policy" "policy" {
  name        = "WebAppS3"
  description = "S3 bucket policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ListObjectsInBucket"
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
        ]
        Resource = ["arn:aws:s3:::${aws_s3_bucket.s3_webapp.bucket}"]
      },
      {
        Sid      = "AllObjectActions"
        Effect   = "Allow"
        Action   = "s3:*Object",
        Resource = ["arn:aws:s3:::${aws_s3_bucket.s3_webapp.bucket}/*"]
      }
    ]
  })
}

resource "aws_iam_role" "ec2_s3" {
  name = "EC2-CSYE6225"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = [aws_iam_policy.policy.arn]
}