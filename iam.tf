# Create policy for access S3
resource "aws_iam_policy" "policy" {
  name        = "WebAppS3"
  description = "S3 bucket policy"

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

# Create IAM role and attach the S3 policy to the role
resource "aws_iam_role" "EC2Role" {
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

# Attach CloudWatchAgentServerPolicy to the IAM role
resource "aws_iam_role_policy_attachment" "CloudWatchAgentServer" {
  role       = aws_iam_role.EC2Role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}