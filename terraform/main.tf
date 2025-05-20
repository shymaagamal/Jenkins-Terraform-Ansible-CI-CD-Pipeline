module "my-network" {
  source = "./modules/network"

  # my module expects a variable called network_my_vpc_cidr_var
  # Left = module var, Right = root var
  network_my_vpc_cidr_var = var.my_vpc_cidr 
  network_my_private_subnet01_cider_block = var.my_private_subnet01_cidr
  network_my_private_subnet02_cider_block = var.my_private_subnet02_cidr
  network_my_public_subnet01_cider_block = var.my_public_subnet01_cidr
  network_my_public_subnet02_cider_block = var.my_public_subnet02_cidr
  network_az1 = var.my_Az1
  network_az2 = var.my_Az2
}
module "my-Alb" {
   source = "./modules/alb"
   alb_sg_id = [module.my-network.networkOUT_albSG_allow_HTTP]
   alb_subnet_ids = [module.my-network.networkOUT_public_subnet01_id,module.my-network.networkOUT_public_subnet02_id]
   alb_tg_vpc_id = module.my-network.networkOUT_vpc_id
}
module "my-public-instances" {
  source = "./modules/instances"
  ec2_bastion_SG = module.my-network.networkOUT_SG_ALLOW_public_SSH
  ec2_bastion_subnet_id = module.my-network.networkOUT_public_subnet01_id
  ec2_instance_type = var.my_bastion_instance_type
  ec2_private_subnet01_id = module.my-network.networkOUT_private_subnet01_id
  ec2_private_SG = module.my-network.networkOUT_SG_ALLOW_ssh_from_public_subnet
  ec2_private_subnet02_id=module.my-network.networkOUT_private_subnet02_id
  ec2__lb_target_group_arn = module.my-Alb.albOUT_targetGroup_arn
 
}