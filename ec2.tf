variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  default = "aws-dev-us-west-2"
}

data "aws_ami" "webapp_ami" {
  filter {
    name   = "name"
    values = ["csye6225_*"]
  }

  most_recent = true
}

# Connect ec2 to S3
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.ec2_s3.name
}

resource "aws_instance" "webapp_instance" {
  ami                         = data.aws_ami.webapp_ami.id
  instance_type               = var.instance_type
  subnet_id                   = [for s in aws_subnet.public_subnets : s.id][0]
  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.webapp_sg.id]

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  # Protect against accidental termination
  disable_api_termination = false

  # Set the root volume size and type
  root_block_device {
    volume_size           = 50
    volume_type           = "gp2"
    delete_on_termination = true
  }

  tags = {
    Name = "Web Application Instance"
  }

  user_data = <<-EOF
      #!/bin/bash
      echo "DB_HOST=${aws_db_instance.postgresql.address}" >> /etc/environment
      echo "DB_PORT=${aws_db_instance.postgresql.port}" >> /etc/environment
      echo "DB_NAME=${aws_db_instance.postgresql.db_name}" >> /etc/environment
      echo "DB_USER=${aws_db_instance.postgresql.username}" >> /etc/environment
      echo "DB_PASSWORD=${aws_db_instance.postgresql.password}" >> /etc/environment
      echo "BUCKET_NAME=${aws_s3_bucket.s3_webapp.bucket}" >> /etc/environment
      sudo systemctl start csye6225webapp
    EOF

  key_name = var.key_name
}
