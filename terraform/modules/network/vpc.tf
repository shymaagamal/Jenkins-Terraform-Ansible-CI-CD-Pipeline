resource "aws_vpc" "network_my_vpc" {
  cidr_block       = var.network_my_vpc_cidr_var

  tags = {
    Name = "my-vpc"
  }
}