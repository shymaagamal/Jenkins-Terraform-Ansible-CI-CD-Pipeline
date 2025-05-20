
# DevOps CI/CD Pipeline with Jenkins, Ansible, and Terraform

## Architecture Overview

### VPC CIDR Block: `10.0.0.0/16`

### Subnets
- **Public Subnet (e.g., `10.0.3.0/24`)**
  - Application Load Balancer (ALB)
  - Bastion EC2 (for Ansible and SSH access)
  
- **Private Subnet 1 (e.g., `10.0.1.0/24`)**
  - Jenkins Master (Docker container on EC2)
  - Jenkins Slave/Agent (EC2)
  - Node.js App Server (EC2)

- **Private Subnet 2 (e.g., `10.0.2.0/24`)**
  - RDS DB Instance (PostgreSQL/MySQL)

## Step-by-Step Guide to Build Infra and CI/CD Pipeline

### 1. Build Infrastructure (Terraform)
- Create:
  - Bastion EC2 in Public Subnet
  - Jenkins Master EC2, Slave EC2, and App Server EC2 in Private Subnet 1
  - RDS Instance in Private Subnet 2
  - Use Terraform modules for EC2s (recommended)

### 2. Access Setup
- SSH to Bastion EC2
- From Bastion, SSH into Private EC2s
- Set up `~/.ssh/config` to use the Bastion as a proxy

### 3. Install & Configure Ansible on Bastion
- Add inventory file for jenkins_master, jenkins_agent, and app_server
- Use Ansible to:
  - Install Docker on Jenkins Master
  - Run Jenkins as Docker container
  - Install Docker on Jenkins Agent and App EC2s
  - Install Node.js and PM2 on App Server

### 4. Jenkins Master Configuration
- Run Jenkins in Docker (port 8080)
- Access via SSH tunneling:
  ```bash
  ssh -i key.pem -L 8080:localhost:8080 ubuntu@<bastion-public-ip>
  ```

### 5. Jenkins Pipeline Setup
- Create Freestyle or Pipeline job
- Add GitHub repo
- Add webhook to GitHub
- Configure SSH credentials
- Setup agent node with label and IP

### 6. CI/CD Pipeline Stages
1. Pull Code from GitHub (`rds_redis` branch)
2. Build Docker Image for Node.js app
3. Push to Docker Hub or ECR
4. SSH to App EC2, pull image, run container
5. Optional: DB migrations
6. Notify Success/Failure

### 7. Application Load Balancer
- In public subnet, allow HTTP (80)
- Target group forwards to app on port 3000

### 8. Final Testing
```
http://<ALB-DNS-Name>/
http://<ALB-DNS-Name>/db
http://<ALB-DNS-Name>/redis
```

### 9. Security Groups
- Bastion: Allow SSH from your IP
- Jenkins/App: Internal communication only
- RDS: Only allow from App or Jenkins
- ALB: Public access on port 80

### 10. Documentation
Include:
- CIDR plan, security rules
- Architecture diagram
- Ansible and Terraform samples
- Jenkins screenshots, ALB URL

## Next Steps Checklist

| Step | Task | Done? |
|------|------|-------|
| 1 | VPC + Subnet infra | ✅ |
| 2 | EC2 instances created | ❓ |
| 3 | Ansible installed on Bastion | ✅ |
| 4 | Ansible playbooks for setup | ❓ |
| 5 | Jenkins container running | ❓ |
| 6 | Jenkins slave connected | ❓ |
| 7 | CI/CD pipeline built | ❓ |
| 8 | ALB configured | ❓ |
| 9 | App accessible via ALB | ❓ |
| 10 | Documentation written | ❓ |
