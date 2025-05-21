resource "aws_instance" "instances_jenkin_master" {
  instance_type = var.ec2_instance_type
  ami = data.aws_ami.ubuntu_ami.id
  associate_public_ip_address= "false"
  vpc_security_group_ids= [var.ec2_private_SG]
  subnet_id =var.ec2_private_subnet01_id
  key_name = aws_key_pair.generated_key.key_name
  tags = {
    Name = "jenkin_master"
  }
}

resource "aws_instance" "instances_jenkin_slave" {
  instance_type = var.ec2_instance_type
  ami = data.aws_ami.ubuntu_ami.id
  associate_public_ip_address= "false"
  vpc_security_group_ids= [var.ec2_private_SG]
  subnet_id =var.ec2_private_subnet01_id
  key_name = aws_key_pair.generated_key.key_name
  tags = {
    Name = "jenkin_slave"
  }
}

resource "aws_instance" "instances_jenkin_slave" {
  instance_type = var.ec2_instance_type
  ami = data.aws_ami.ubuntu_ami.id
  associate_public_ip_address= "false"
  vpc_security_group_ids= [var.ec2_private_SG]
  subnet_id =var.ec2_private_subnet01_id
  key_name = aws_key_pair.generated_key.key_name
  tags = {
    Name = "jenkin_slave2"
  }
}
resource "aws_instance" "instances_jenkin_slave" {
  instance_type = var.ec2_instance_type
  ami = data.aws_ami.ubuntu_ami.id
  associate_public_ip_address= "false"
  vpc_security_group_ids= [var.ec2_private_SG]
  subnet_id =var.ec2_private_subnet01_id
  key_name = aws_key_pair.generated_key.key_name
  tags = {
    Name = "jenkin_slave5"
  }
}
