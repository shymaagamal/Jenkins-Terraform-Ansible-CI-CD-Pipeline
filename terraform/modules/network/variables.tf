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
variable "network_my_public_subnet01_cider_block" {
  type = string
 
  description = "The cidr block of VPC."
}
variable "network_my_public_subnet02_cider_block" {
  type = string
 
  description = "The cidr block of VPC."
}
variable "network_az1" {
  type = string
 
  description = "The az that my private subnet01 and public subnet belongs to"
}
variable "network_az2" {
  type = string
 
  description = "The az that my private subnet02"
}

