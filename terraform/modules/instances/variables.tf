variable "ec2_instance_type" {
    type = string
    description = "this is type of EC2 e.g t2.micro"
  
}
variable "ec2_bastion_SG" {
    type = string
    description = "this is SG iD of EC2"
}
variable "ec2_private_SG" {
    type = string
    description = "this is SG iD of EC2"
}
variable "ec2_bastion_subnet_id" {
      type = string
    description = "this is subnet iD of EC2"
}
variable "ec2_private_subnet_id" {
      type = string
    description = "this is subnet iD of EC2"
}