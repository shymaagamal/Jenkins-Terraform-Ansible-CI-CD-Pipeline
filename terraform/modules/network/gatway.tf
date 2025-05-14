resource "aws_internet_gateway" "network_gatway" {
  vpc_id = aws_vpc.network_my_vpc.id

  tags = {
    Name = "my-gatway"
  }
}