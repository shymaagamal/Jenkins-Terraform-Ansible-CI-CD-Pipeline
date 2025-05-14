module "my-network" {
  source = "./modules/network"

  # my module expects a variable called network_my_vpc_cidr_var
  # Left = module var, Right = root var
  network_my_vpc_cidr_var = var.my_vpc_cidr 
  network_my_private_subnet01_cider_block = var.my_private_subnet01_cidr
  network_my_private_subnet02_cider_block = var.my_private_subnet02_cidr
  network_my_public_subnet_cider_block = var.my_public_subnet_cidr
  
}
module "my-public-instances" {
  source = "./modules/instances"
  ec2_bastion_SG = module.my-network.networkOUT_SG_ALLOW_public_SSH
  ec2_bastion_subnet_id = module.my-network.networkOUT_public_subnet_id
  ec2_instance_type = var.my_bastion_instance_type
  ec2_private_subnet_id = module.my-network.networkOUT_private_subnet01_id
  ec2_private_SG = module.my-network.networkOUT_SG_ALLOW_ssh_from_public_subnet

}