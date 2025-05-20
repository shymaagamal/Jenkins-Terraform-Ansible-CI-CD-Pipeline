
resource "aws_launch_template" "instances_app_template" {
  name_prefix   = "ubuntu-app-template"
  image_id      = data.aws_ami.ubuntu_ami.id
  instance_type =  var.ec2_instance_type
  key_name = aws_key_pair.generated_key.key_name
  vpc_security_group_ids= [var.ec2_private_SG]
    tags = {
      Name = "asg-app-instance"
    }


}

resource "aws_autoscaling_group" "instances_app_ASG" {
  desired_capacity   = 2
  max_size           = 3
  min_size           = 2
  vpc_zone_identifier=[var.ec2_private_subnet01_id,var.ec2_private_subnet02_id]
  launch_template {
    id      = aws_launch_template.instances_app_template.id
    version = "$Latest"
  }
  target_group_arns = [var.ec2__lb_target_group_arn]
  tag {
    key                 = "Name"
    value               = "asg-app-instance"
    propagate_at_launch = true
  }
}