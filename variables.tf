variable "aws_profile" {
  type        = string
  description = "AWS profile"
}

variable "aws_region" {
  type        = string
  description = "Aws region to create VPC in"
}

variable "project_name" {
  description = "Name of the VPC"
}

variable "cidr_block" {
  type        = string
  description = "VPC CIDR block values"
}

variable "public_subnets" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))

  description = "Public Subnet CIDR and AZ values"
}

variable "private_subnets" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))

  description = "Private Subnet CIDR and AZ values"
}
