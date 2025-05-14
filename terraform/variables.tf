
# VPC vars
variable "my_vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC to pass into the module"
}


# Subnet vars
variable "my_private_subnet01_cidr" {
  type        = string
  description = "CIDR block for the private subnet to pass into the module"
}

variable "my_private_subnet02_cidr" {
  type        = string
  description = "CIDR block for the private subnet to pass into the module"
}
variable "my_public_subnet_cidr" {
  type        = string
  description = "CIDR block for the private subnet to pass into the module"
}

variable "my_bastion_instance_type" {
  type= string
  description = "this is type of EC2  like t3.micro"
}