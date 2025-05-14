resource "aws_subnet" "network_private_subnet01" {
  vpc_id     = aws_vpc.network_my_vpc.id
  cidr_block = var.network_my_private_subnet01_cider_block

  tags = {
    Name = "private_subnet01"
  }
}

resource "aws_subnet" "network_private_subnet02" {
  vpc_id     = aws_vpc.network_my_vpc.id
  cidr_block = var.network_my_private_subnet02_cider_block

  tags = {
    Name = "private_subnet02"
  }
}

resource "aws_subnet" "network_public_subnet" {
  vpc_id     = aws_vpc.network_my_vpc.id
  cidr_block = var.network_my_public_subnet_cider_block

  tags = {
    Name = "public_subnet"
  }
}