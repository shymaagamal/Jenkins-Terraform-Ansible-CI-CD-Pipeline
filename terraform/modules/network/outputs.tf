output "networkOUT_vpc_id" {
  value = aws_vpc.network_my_vpc.id
  description = "The id of VPC"
}

output "networkOUT_private_subnet01_id" {
  value = aws_subnet.network_private_subnet01.id
  description = "The id of private subnet01"
}

output "networkOUT_private_subnet02_id" {
  value = aws_subnet.network_private_subnet02.id
  description = "The id of private subnet02"
}

output "networkOUT_public_subnet_id" {
  value = aws_subnet.network_public_subnet.id
  description = "The id of public subnet"
}


output "networkOUT_SG_ALLOW_public_SSH" {
  value = aws_security_group.network_SG_ALLOW_public_SSH.id
  description = "Allow SSH from any IP and all outbound traffic"
  
}

output "networkOUT_SG_ALLOW_ssh_from_public_subnet" {
  value = aws_security_group.network_SG_ALLOW_ssh_from_public_subnet.id
  description = "Allow SSH from bastion host only from public subnet"
  
}

output "networkOUT_dbSG_ALLOW_ssh_from_private_subnet" {
  value = aws_security_group.network_dbSG_ALLOW_ssh_from_private_subnet.id
  description = "Allow SSH from App instance only from private subnet"
  
}