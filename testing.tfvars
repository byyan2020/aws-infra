aws_profile = "demo"

aws_region = "us-west-2"

project_name = "demo3"

cidr_block = "100.10.0.0/16"

public_subnets = {
  public_subnets_1 = {
    cidr_block        = "100.10.1.0/24"
    availability_zone = "us-west-2a"
  },
  public_subnets_2 = {
    cidr_block        = "100.10.2.0/24"
    availability_zone = "us-west-2b"
  }
  public_subnets_3 = {
    cidr_block        = "100.10.3.0/24"
    availability_zone = "us-west-2c"
  }
}

private_subnets = {
  private_subnets_1 = {
    cidr_block        = "100.10.4.0/24"
    availability_zone = "us-west-2a"
  },
  private_subnets_2 = {
    cidr_block        = "100.10.5.0/24"
    availability_zone = "us-west-2b"
  }
  private_subnets_3 = {
    cidr_block        = "100.10.6.0/24"
    availability_zone = "us-west-2c"
  }
}


