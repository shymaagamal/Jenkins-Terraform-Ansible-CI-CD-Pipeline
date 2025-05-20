resource "aws_route_table_association" "network_private_subnet01_association" {
  subnet_id =aws_subnet.network_private_subnet01.id
  route_table_id = aws_route_table.network_private_routetable.id
}

resource "aws_route_table_association" "network_public_subnet01_association" {
  subnet_id = aws_subnet.network_public_subnet01.id
  route_table_id = aws_route_table.network_public_routetable.id
}

resource "aws_route_table_association" "network_public_subnet02_association" {
  subnet_id = aws_subnet.network_public_subnet02.id
  route_table_id = aws_route_table.network_public_routetable.id
}
resource "aws_route_table_association" "network_private_subnet02_association" {
  subnet_id = aws_subnet.network_private_subnet02.id
  route_table_id = aws_route_table.network_private_routetable.id
}