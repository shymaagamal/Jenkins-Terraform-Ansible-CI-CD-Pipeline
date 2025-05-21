## 📌 Project Overview
This project implements a modern, fully automated **CI/CD pipeline** that integrates **Jenkins**, **Ansible**, and **Terraform**, triggered seamlessly via **GitHub**.

- **Terraform** is responsible for provisioning the underlying cloud infrastructure. It uses a modular structure to create and manage essential components such as VPCs, private and public subnets, EC2 instances, and Application Load Balancers (ALBs). This modularity ensures the infrastructure is scalable, reusable, and easy to maintain or extend.

- **Ansible** handles the configuration management and orchestration. It automates the installation and setup of Jenkins master and slave nodes, as well as application deployment on the provisioned EC2 instances. Using roles and playbooks promotes clear separation of concerns and reusable automation scripts.

- **Jenkins** serves as the CI/CD orchestration engine. It automates the building, testing, and deployment of the application. The pipeline triggered by GitHub events (such as commits and pull requests) ensures continuous integration and delivery, accelerating development cycles while maintaining high reliability.

- **GitHub** acts as the version control system and the trigger mechanism for the pipeline. Integration with GitHub enables automated pipeline runs on code changes, promoting rapid feedback and seamless collaboration among development teams.

Together, these tools provide a robust, scalable, and maintainable pipeline solution that enhances deployment speed, improves operational reliability, and supports future growth and complexity.


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

I copied my local `ansible` directory to the bastion EC2 instance using the following command:

```bash
scp -r -i ./my_key.pem ./ansible ubuntu@44.195.87.2:/home/ubuntu/
```

### Sync Changes to EC2 Using rsync
* To efficiently sync changes from my local ansible directory to the bastion EC2 instance, I used this command:
```bash
rsync -avz -e "ssh -i my_key.pem" ./ansible/ ubuntu@44.195.87.2:/home/ubuntu/ansible/
```
### Running Ansible Playbooks
* fter copying or syncing the Ansible files to the bastion EC2 instance, I executed the playbooks to configure the infrastructure and deploy the applications.
```bash
ansible-playbook plays/app.yaml
ansible-playbook plays/jenkins-master.yaml
ansible-playbook plays/jenkins-slave.yaml
```

### Access Jenkins Dashboard via SSH Port Forwarding
* Jenkins runs in a private subnet, so direct access is restricted. To access the Jenkins web interface securely, I set up SSH port forwarding through the bastion host.
```markdown
ssh -i my_key.pem -L <local-port>:<target-private-ip>:<target-port> ubuntu@<bastion-public-ip>
```
**Example:**
```bash
ssh -i my_key.pem -L 8080:10.0.2.100:8080 ubuntu@18.234.100.5
```

## Jenkins Master and Slave SSH Key Setup
I generated an SSH key pair inside the Jenkins master container and copied the public key to the Jenkins slave container to enable secure, passwordless SSH communication between them.

### Important Notes:
* The infrastructure includes two private EC2 instances: one hosting the Jenkins master container and the other hosting the Jenkins slave container.

* his setup enables the Jenkins master to securely SSH into the slave container to execute jobs seamlessly, eliminating the need for manual password entry.

### 📌 Steps:
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


### 🛠️ Jenkins Agent (Slave) GUI Configuration

To configure the Jenkins slave (agent) node via the Jenkins UI, follow these steps:

1. Go to **Manage Jenkins** → **Manage Nodes and Clouds** → **New Node**.
2. Enter a name (e.g., `slave`) and select **Permanent Agent**, then click **OK**.
3. Fill out the configuration form using the following values:

| Field                     | Value (Example)                                                                 |
|---------------------------|----------------------------------------------------------------------------------|
| **# of Executors**        | `2` — Allows 2 parallel jobs on this agent                                      |
| **Remote root directory** | `/home/jenkins` — This is the home directory for the agent (on EC2/container)   |
| **Labels**                | `slave` — Used to assign specific jobs to this agent                            |
| **Usage**                 | Use this node as much as possible                                               |
| **Launch Method**         | ✅ Select **"Launch agents via SSH"**                                           |
| **Host**                  | `10.0.1.224` — Private IP of the slave EC2 instance                             |
| **Credentials**           | Select SSH credentials for the `jenkins` user (must be preconfigured in Jenkins)|
| **Host Key Verification Strategy** |Known hosts file Verification Strategy   |
| **SSH Port**              | `2222`         |

4. Click **Save**.


### 📌 Adding Slave to Known Hosts (Manually)

Before configuring the connection in the Jenkins GUI, I manually added the slave’s SSH host key to the Jenkins master’s `known_hosts` file to avoid host key verification issues.

I ran the following command **inside the Jenkins master container**:

```bash
ssh-keyscan -p 2222 10.0.1.224 >> /var/jenkins_home/.ssh/known_hosts
```
## 🔧🚀 Creating a Jenkins Pipeline
### 📌 Steps:
- Create a New Pipeline Job
-  Click “New Item” →
-  Enter a name like my-pipeline →
- Choose Pipeline → Click OK
- In Triggers section → check `GitHub hook trigger for GITScm polling` 
- Scroll down to Pipeline Definition
- Choose Pipeline script from SCM
- Set: SCM: Git
- Repository URL: [this GitHub Repo](https://github.com/shymaagamal/Jenkins-Terraform-Ansible-CI-CD-Pipeline.git)


- Credentials: add GitHub creds
- Branches to build: */main 
- Jenkinsfile location: Jenkinsfile (root)
## 🌐 Setting Up ngrok to Expose Jenkins
When using GitHub webhooks with Jenkins on a private/local network (e.g., localhost:8080), GitHub can't reach my machine directly.
That's where ngrok comes in — it exposes my local Jenkins server to the internet securely via a public URL
### 🚀 Steps
- Register for an ngrok Account
Before using ngrok, create a free account here and get my personal auth token:
[👉 Get Your ngrok Authtoken](https://dashboard.ngrok.com/get-started/your-authtoken)
-  Install ngrok on my Local Machine:[Linux installation guide](https://ngrok.com/downloads/linux?tab=snap)
- Authenticate ngrok with my Token
After installation, connect your machine to my ngrok account by running
```bash
ngrok config add-authtoken <MY_NGROK_TOKEN>
```
- Start Port Forwarding Jenkins (Port 8080)
```bash
ngrok http 8080
```
> **📎 Copy this URL — you'll need it for your GitHub webhook setup:**  
> 👉 `https://abcd1234.ngrok.io`

### 🔧 Updating Jenkins URL with ngrok Public URL
- Open Jenkins in my browser (using http://localhost:8080).
-  Manage Jenkins → Configure System
- scroll to the section Jenkins URL.
- Replace the default (http://localhost:8080) with my ngrok URL:
`https://abcd1234.ngrok.io`
- Click Save.

🔗 This step is essential — GitHub uses this URL to send webhook payloads. If it's not set correctly, your webhook won't trigger the pipeline!

## Creating a GitHub Webhook
- Navigate to Settings → Webhooks → Add Webhook
- Payload URL: `https://abcd1234.ngrok.io`/github-webhook/
- Content type: application/json
- Which events? → Choose Just the push event
- Click Add Webhook

`💡 Note: Jenkins automatically handles /github-webhook/ if GitHub plugin is installed.`


