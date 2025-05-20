resource "aws_instance" "instances_bastion" {
  instance_type = var.ec2_instance_type
  ami = data.aws_ami.ubuntu_ami.id
  associate_public_ip_address= "true"
  vpc_security_group_ids= [var.ec2_bastion_SG]
  subnet_id =var.ec2_bastion_subnet_id
  key_name = aws_key_pair.generated_key.key_name
  tags = {
    Name = "bastion"
  }
}