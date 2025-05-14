# VPC module vars
variable "network_my_vpc_cidr_var" {
  type = string
 
  description = "The cidr block of VPC."
}


# Subnets Modeule vars 
variable "network_my_private_subnet01_cider_block" {
  type = string
 
  description = "The cidr block of VPC."
}

variable "network_my_private_subnet02_cider_block" {
  type = string
 
  description = "The cidr block of VPC."
}
variable "network_my_public_subnet_cider_block" {
  type = string
 
  description = "The cidr block of VPC."
}