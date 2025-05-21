## 📌 Project Overview
This project implements a modern CI/CD pipeline leveraging Jenkins, Ansible, and Terraform, fully automated and triggered via GitHub.

Terraform provisions the cloud infrastructure, including VPCs, subnets, EC2 instances, and load balancers, using a modular approach to ensure scalability and reusability.

Ansible configures the deployed infrastructure by installing and managing Jenkins master and slave nodes as well as the application deployment.

Jenkins orchestrates the CI/CD workflows, automating build, test, and deployment processes for the application.

GitHub serves as the source control and trigger mechanism, where code commits and pull requests initiate the pipeline execution, ensuring continuous integration and continuous delivery.

This combination provides a robust, automated, and scalable pipeline that accelerates development cycles, improves reliability, and supports easy maintenance and extension.

## 📁 Project Structure 
```
terraform/
├── main.tf            # The main entry point that calls modules and resources
├── local.tf           # Defines local variables used throughout the project
├── variable.tf        # Declares input variables for this Terraform configuration
├── terraform.tf       # Terraform settings file (state config, version constraints)
├── provider.tf        # Provider configurations (e.g., AWS provider details)
├── backend.tf         # Backend configuration for remote state storage (e.g., S3)
└── modules/           # Contains reusable Terraform modules
    ├── network/       # Module for VPC, subnets, security groups, routing tables
    ├── instances/     # Module for EC2 instances, launch templates, autoscaling
    └── alb/           # Module for Application Load Balancer (ALB) and target groups
ansible/
├── plays/             # Playbooks that define orchestration workflows
│   ├── jenkins-master.yaml    # Playbook to deploy and configure Jenkins Master node
│   ├── jenkins-slave.yaml     # Playbook to deploy and configure Jenkins Slave node(s)
│   └── app.yaml               # Playbook for deploying and configuring the custom application
└── roles/             # Roles encapsulate reusable tasks, handlers, templates, and vars
    ├── jenkins-master/       # Role for Jenkins Master installation and setup
    ├── jenkins-slave/        # Role for Jenkins Slave configuration and registration
    └── app/                  # Role for deploying the custom application and dependencies


```
## Working with Ansible and Accessing Jenkins Dashboard

### Copy Ansible Directory to bastion EC2

To copy your local `ansible` directory to your bastion EC2 instance, run:

```bash
scp -r -i ./my_key.pem ./ansible ubuntu@44.195.87.2:/home/ubuntu/
```

### Sync Changes to EC2 Using rsync
* To efficiently sync changes from your local ansible directory to the bastion EC2 instance, use:
```bash
rsync -avz -e "ssh -i my_key.pem" ./ansible/ ubuntu@44.195.87.2:/home/ubuntu/ansible/
```
### Running Ansible Playbooks
* After copying or syncing the Ansible files to the bastion EC2 instance , execute the playbooks to configure your infrastructure or deploy applications.

```bash
ansible-playbook plays/app.yaml
ansible-playbook plays/jenkins-master.yaml
ansible-playbook plays/jenkins-slave.yaml
```

### Access Jenkins Dashboard via SSH Port Forwarding
* Jenkins runs in a private subnet, so direct access is restricted. To access the Jenkins web interface securely, use SSH port forwarding through the bastion host:
```markdown
ssh -i my_key.pem -L <local-port>:<target-private-ip>:<target-port> ubuntu@<bastion-public-ip>
```
**Example:**
```bash
ssh -i my_key.pem -L 8080:10.0.2.100:8080 ubuntu@18.234.100.5
```

## Jenkins Master and Slave SSH Key Setup
To enable secure and seamless communication between your Jenkins master and slave nodes, you need to generate an SSH key pair on the Jenkins master container and copy the public key to the Jenkins slave container.
### Important Notes:
* You should have two private EC2 instances: one running the Jenkins master container, and the other running the Jenkins slave container.

* This setup allows the master to securely connect to the slave for executing jobs without needing to manually enter passwords.

### Steps:
* Generate SSH Key on the Jenkins Master Container
  First, access your Jenkins master container:
```bash
  sudo docker exec -it jenkins-master-container bash
```
* Inside the container, generate an SSH key pair (if not already created):
```bash
ssh-keygen
```
* Copy the Public Key to the Jenkins Slave Container
Next, copy the public key content from the master container:
```bash
cat ~/.ssh/id_rsa.pub

```
* Then, access your Jenkins slave container ans copy public key in authorized_keys file:
```bash
sudo docker exec -it jenkins-slave-container bash
touch ~/.ssh/authorized_keys
```
### ⚠️ Note:
Make sure that:

✅ The Jenkins master EC2 instance can ping the Jenkins slave EC2 instance:
```bash
ping <slave-private-ip>

```
✅ The Jenkins master container can successfully SSH into the Jenkins slave container using port 2222:

```bash
ssh -p 2222 jenkins@10.0.1.224
```

This ensures that Jenkins jobs can be delegated from the master to the slave node without issues.

🛠️ You may need to:

Adjust Security Group rules to allow:
- ICMP (for ping)
- TCP port 22 (for normal SSH)
- TCP port 2222 (for container-to-container SSH, if mapped)
- Ensure proper routing and subnet configuration (especially in private networks).
- Generate an SSH key inside the Jenkins master container, and copy the public key to the slave container's ~/.ssh/authorized_keys.