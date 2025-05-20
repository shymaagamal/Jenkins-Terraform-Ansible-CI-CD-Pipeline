`` scp -r -i ./my_key.pem ./ansible ubuntu@44.195.87.2:/home/ubuntu/ ``
use this to copy local ansible dir to ec2

`` rsync -avz -e "ssh -i my_key.pem" ./ansible/ ubuntu@44.195.87.2:/home/ubuntu/ansible/ ``
and this command to sync changes

`` ansible-playbook plays/app.yaml`` 
then run this command on bastion host to install nginx in app ec2s