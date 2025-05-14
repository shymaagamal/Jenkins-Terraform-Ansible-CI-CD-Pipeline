# 📘 Terraform AWS Network Architecture (VPC, Subnets, Route Tables, and Security Groups)

## 📌 Project Overview

This project defines the **network layer** for an AWS environment using Terraform. It includes the setup of a VPC, private and public subnets, route tables, internet/NAT gateway configuration, and security groups to securely host an RDS instance and application servers.

---

## 📐 Architecture Summary

### 🔧 Components

* **VPC** with CIDR block: `10.0.0.0/16`
* **3 Subnets:**

  * `10.0.1.0/24` - Private Subnet 01 (for RDS)
  * `10.0.2.0/24` - Private Subnet 02 (for backend/app EC2)
  * `10.0.3.0/24` - Public Subnet (for NAT Gateway / Bastion / Load Balancer)

### 📊 Route Tables

* **Public Route Table:**

  * Associated with Public Subnet
  * Routes `0.0.0.0/0` → Internet Gateway

* **Private Route Table (App):**

  * Associated with Private Subnet 02
  * Routes `0.0.0.0/0` → NAT Gateway (for outbound internet access)

* **Private Route Table (DB):**

  * Associated with Private Subnet 01
  * No route to internet (unless needed for updates via NAT)

---

## 🔐 Security Group Design

### 📡 Public Security Group (Bastion / Load Balancer)

* **Allow Inbound:**

  * SSH (port `22`) from `0.0.0.0/0` *(for Bastion testing only — restrict in production)*
  * HTTP/HTTPS from `0.0.0.0/0` *(for ALB)*
* **Allow Outbound:** All traffic

### 📦 App Security Group (EC2 in private subnet)

* **Allow Inbound:**

  * From ALB Security Group on app port (e.g., `3000` or `80`)
* **Allow Outbound:**

  * MySQL/PostgreSQL port to RDS SG
  * Internet (via NAT)

### 🗃️ RDS Security Group

* **Allow Inbound:**

  * Port `3306` (MySQL) or `5432` (Postgres)
  * From App SG only (using `security_groups`)
* **Allow Outbound:** All traffic (default for most cases)

---

## 📁 Project Structure

```
terraform-network/
├── main.tf                   # Root main entry to call modules
├── variables.tf              # Input variables at root
├── terraform.tfvars          # Variable values
├── modules/
│   └── network/
│       ├── vpc.tf
│       ├── subnets.tf
│       ├── route_tables.tf
│       ├── nat_gateway.tf
│       ├── internet_gateway.tf
│       ├── security_groups.tf
│       ├── variables.tf
│       └── outputs.tf
└── README.md                # This file
```

---

## 🔄 Terraform Module Inputs Example

### Root `terraform.tfvars`

```hcl
my_vpc_cidr           = "10.0.0.0/16"
public_subnet_cidr    = "10.0.3.0/24"
private_subnet1_cidr  = "10.0.1.0/24"
private_subnet2_cidr  = "10.0.2.0/24"
```

### Module Call in `main.tf`

```hcl
module "my-network" {
  source               = "./modules/network"
  my_vpc_cidr          = var.my_vpc_cidr
  public_subnet_cidr   = var.public_subnet_cidr
  private_subnet1_cidr = var.private_subnet1_cidr
  private_subnet2_cidr = var.private_subnet2_cidr
}
```

---

## 📝 Outputs from Module (Example)

```hcl
output "vpc_id" {
  value       = aws_vpc.network_my_vpc.id
  description = "The ID of the created VPC"
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}
```

---

## ✅ Best Practices

* Use **least privilege** in SGs
* Keep **RDS in a private subnet** with no direct internet
* Use **NAT Gateway** only when needed (adds cost)
* Don't open ports like SSH to `0.0.0.0/0` in production
* Document module inputs/outputs clearly

---

## 📣 Future Enhancements

* Add ALB and EC2 module
* Add NAT Gateway only for app tier
* Add Route53 private DNS support
* Enable Flow Logs for VPC for audit

---

Let me know if you'd like this architecture diagrammed visually too!
