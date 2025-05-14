* ## Public Subnet
- **Bastion Host:** Runs Ansible control so you can SSH into private hosts securely 
Medium


- **Application Load Balancer (ALB):** Receives HTTP(S) traffic from the internet and forwards to your app servers

* ## Private Subnet #1 (10.0.1.0/24) 
- **Jenkins Master:** Orchestrates pipelines, holds job configs, and dispatches builds to agents 
Jenkins


- **Jenkins Agent (Slave):** Executes build steps (e.g., npm install, npm test) on demand—keeping heavy work off the master and allowing parallelism 
Reddit


- **App EC2:** Hosts your long-running Node.js application behind the ALB.

* ## Private Subnet #2 (10.0.2.0/24)

- **RDS Instance:** Runs your relational database (MySQL/Postgres) with no public exposure; SG allows only the app EC2 or Jenkins agent to connect

# At its core, i'm building an automated pipeline on AWS that:

1.  Provisions infrastructure (VPC, subnets, NAT, load balancer, RDS) with Terraform.

2. Configures servers (Jenkins master/agents, app hosts) via Ansible running on a bastion host.

3. Runs your build-and-deploy workflow using Jenkins: the Master coordinates jobs, Agents execute them, and your Node.js app is automatically built, tested, and pushed to its EC2 servers behind an ALB.

# What This Project Does
1. **Network & Security:** Creates a VPC (10.0.0.0/16) with one public subnet (for Bastion & ALB) and two private subnets (one for Jenkins/App, one for RDS) 

2. **Server Setup:** Uses Ansible on the bastion to install and configure Jenkins (master and agents) and your Node.js runtime on designated EC2 instances 

3. **Database:** Launches an RDS database in a private subnet, accessible only by your app and build agents via a locked-down security group 

4. **Load Balancing:** Places an ALB in the public subnet to route HTTP(S) traffic to your private app servers transparently 


# Simplified Workflow
1. Commit & Push your code to GitHub.

2. Jenkins Master detects the change and dispatches the job to an available Agent labeled nodejs 


3. Agent checks out the code, runs ``npm install`` & ``npm test``, then packages the app.

4. Agent or Master then deploys the package (using Ansible or SSH) to the Node.js EC2 instance behind the ALB.

5. ALB begins routing user traffic to the updated app automatically.


# Role Clarification
* **Master:** thinks, schedules, coordinates, stores logs/artifacts.

* **Agent:** executes steps on its machine—compiling, testing, deploying.

* **App Server:** runs your Node.js process long-term, serving real users.

* **Bastion/Ansible:** bootstraps and maintains the above machines via secure SSH.