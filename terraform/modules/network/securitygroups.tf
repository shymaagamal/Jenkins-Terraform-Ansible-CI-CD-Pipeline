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
  name        = "network_SG_ALLOW_ssh_to_private_subnet"
  description = "Allow SSH from any IP from public subnet only and all outbound traffic to nat-gatway"
  vpc_id      = aws_vpc.network_my_vpc.id

  ingress {
    description = "SSH from public subnet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.network_public_subnet01.cidr_block]
  }
ingress {
  description              = "HTTP from ALB"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_groups          = [aws_security_group.network_albSG_allow_HTTP.id]
}
ingress {
  description = "Allow SSH from self"
  from_port   = 2222
  to_port     = 2222
  protocol    = "tcp"
  self        = true
}
ingress {
  description = "Allow ICMP (ping) from self"
  from_port   = -1
  to_port     = -1
  protocol    = "icmp"
  self        = true
}
ingress {
  description = "Jenkins Port 8080 from Bastion Host"
  from_port   = 8080
  to_port     = 8080
  protocol    = "tcp"
  cidr_blocks = [aws_subnet.network_public_subnet01.cidr_block]
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


resource "aws_security_group" "network_albSG_allow_HTTP" {
  name        = "alb-sg"
  description = "Allow HTTP access to ALB"
  vpc_id      =  aws_vpc.network_my_vpc.id


  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}
