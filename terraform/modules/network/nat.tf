resource "aws_nat_gateway" "network_nat_gatway" {
  allocation_id = aws_eip.network_eIP.id
  subnet_id     = aws_subnet.network_public_subnet.id
}