resource "aws_vpc" "main" {
  cidr_block = var.cidr_block

  instance_tenancy = "default"
  tags = {
    Name = "${var.project_name}-VPC"
  }
}

resource "aws_subnet" "public_subnets" {
  for_each          = var.public_subnets
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = {
    Name = "${var.project_name}-${each.key}"
  }
}

resource "aws_subnet" "private_subnets" {
  for_each          = var.private_subnets
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = {
    Name = "${var.project_name}-${each.key}"
  }
}

resource "aws_internet_gateway" "gw" {
  depends_on = [
    aws_vpc.main,
  ]
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-IG"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}-Private Route Table"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.project_name}-Public Route Table"
  }
}

resource "aws_route_table_association" "public_subnet_asso" {
  for_each       = aws_subnet.public_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_subnet_asso" {
  for_each       = aws_subnet.private_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt.id
}
