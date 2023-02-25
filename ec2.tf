variable "instance_type" {
  default = "t2.micro"
}

data "aws_ami" "webapp_ami" {
  filter {
    name   = "name"
    values = ["csye6225_*"]
  }

  most_recent = true
}

resource "aws_instance" "webapp_instance" {
  ami                         = data.aws_ami.webapp_ami.id
  instance_type               = var.instance_type
  subnet_id                   = [for s in aws_subnet.public_subnets : s.id][0]
  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.webapp_sg.id]

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
}
