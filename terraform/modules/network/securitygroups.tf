resource "aws_security_group" "network_SG_ALLOW_public_SSH" {
  name        = "network_SG_ALLOW_public_SSH"
  description = "Allow SSH from any IP and all outbound traffic"
  vpc_id      = aws_vpc.network_my_vpc.id

  ingress {
    description = "SSH from any IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Public Instance SG"
  }
}


resource "aws_security_group" "network_SG_ALLOW_ssh_from_public_subnet" {
  name        = "network_SG_ALLOW_ssh_from_private_subnet"
  description = "Allow SSH from any IP from public subnet only and all outbound traffic to nat-gatway"
  vpc_id      = aws_vpc.network_my_vpc.id

  ingress {
    description = "SSH from any IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.network_public_subnet.cidr_block]
  }

  egress {
    description = "Allow all outbound traffic to NAT Gateway"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Public Instance SG"
  }
}


resource "aws_security_group" "network_dbSG_ALLOW_ssh_from_private_subnet" {
  name        = "network_dbSG_ALLOW_ssh_from_private_subnet"
  description = "Allow SSH from any IP from private subnet only and all outbound traffic to private"
  vpc_id      = aws_vpc.network_my_vpc.id

  ingress {
    description = "SSH from any IP"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.network_private_subnet01.cidr_block]
  }

  egress {
    description = "Allow all outbound traffic to NAT Gateway"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Public Instance SG"
  }
}