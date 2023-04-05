data "template_file" "user_data" {
  template = <<-EOF
      #!/bin/bash
      echo "DB_HOST=${aws_db_instance.postgresql.address}" >> /etc/environment
      echo "DB_PORT=${aws_db_instance.postgresql.port}" >> /etc/environment
      echo "DB_NAME=${aws_db_instance.postgresql.db_name}" >> /etc/environment
      echo "DB_USER=${aws_db_instance.postgresql.username}" >> /etc/environment
      echo "DB_PASSWORD=${aws_db_instance.postgresql.password}" >> /etc/environment
      echo "BUCKET_NAME=${aws_s3_bucket.s3_webapp.bucket}" >> /etc/environment
      echo "LOG_PATH=/home/ec2-user/csye6225" >> /etc/environment

      sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
        -a fetch-config \
        -m ec2 \
        -c file:/opt/cloudwatch-config.json \
        -s

      sudo systemctl start csye6225webapp
    EOF
}

data "aws_ami" "webapp_ami" {
  filter {
    name   = "name"
    values = ["csye6225_*"]
  }

  most_recent = true
}

variable "key_name" {
  default = "aws-dev-us-west-2"
}

# Connect ec2 to S3
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.EC2Role.name
}

resource "aws_launch_template" "csye6225_lt" {
  name = "asg_launch_config"

  image_id = data.aws_ami.webapp_ami.id

  instance_type = "t2.micro"

  key_name = var.key_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.webapp_sg.id]
  }

  user_data = base64encode(data.template_file.user_data.rendered)

  iam_instance_profile {
    name = "ec2_profile"
  }
}
