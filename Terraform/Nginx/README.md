# Terraform AWS Nginx Lab

Spin up a minimal, AWS stack for practicing Terraform:

* **Networking:** 1 VPC, 2 public subnets, 2 private subnets, NAT + IGW, route tables
* **Compute:** Auto Scaling Group (ASG) of EC2 instances running **Nginx** (user‑data)
* **Load Balancing:** Internet‑facing **Application Load Balancer (ALB)**
* **Observability:** ALB/EC2 health checks, basic outputs, tags

> ⚠️ **Cost note:** This demo creates billable resources (ALB, NAT, EC2, etc.). Use a small instance type and **destroy** when finished.

---

## 1) Architecture

```
Internet
   │
   ▼
[ ALB (HTTP/80) ]  ─────────►  Targets: EC2 in private subnets (ASG)
   │
   ├── Subnet A (public)      ─ IGW route, ALB + NAT GW
   └── Subnet B (public)      ─ IGW route, ALB + NAT GW (optional/alt design)

VPC (CIDR e.g., 10.0.0.0/16)
   ├── Public Subnet A (10.0.1.0/24)
   ├── Public Subnet B (10.0.2.0/24)
   ├── Private Subnet A (10.0.11.0/24)  ─ EC2 (ASG)
   └── Private Subnet B (10.0.12.0/24)  ─ EC2 (ASG)
```

* **ALB** lives in public subnets.
* **EC2** instances are in **private** subnets (egress via NAT) and receive traffic only through the ALB.
* **Security Groups** restrict inbound/outbound as appropriate.

---

## 2) Prerequisites

* Terraform **v1.6+** (recommended v1.7 or newer)
* AWS CLI configured (or environment variables) with an account that can create VPC/EC2/ELB/IAM
* An S3 backend for remote state & locking

## 3) Project layout (suggested)

```
terraform-aws-nginx-lab/
├─ modules/
│  ├─ vpc/
│  └─ web/
├─ envs/
│  └─ default/            # root working dir (main/variables/outputs/backend)
│     ├─ main.tf
│     ├─ variables.tf
│     ├─ outputs.tf
│     └─ terraform.tfvars # your values
└─ README.md
```

---

## 4) Variables (common)

| Name                 | Type         | Default                           | Description                        |
| -------------------- | ------------ | --------------------------------- | ---------------------------------- |
| `project_name`       | string       |                                   | Name prefix for tags and resources |
| `region`             | string       | `eu-central-1`                    | AWS region                         |
| `vpc_cidr`           | string       | `10.0.0.0/16`                     | VPC CIDR block                     |
| `public_subnets`     | list(string) | `["10.0.1.0/24","10.0.2.0/24"]`   | Public subnet CIDRs                |
| `private_subnets`    | list(string) | `["10.0.11.0/24","10.0.12.0/24"]` | Private subnet CIDRs               |
| `instance_type`      | string       | `t3.micro`                        | EC2 type for ASG                   |
| `desired_capacity`   | number       | `2`                               | ASG desired capacity               |
| `min_size`           | number       | `2`                               | ASG min size                       |
| `max_size`           | number       | `3`                               | ASG max size                       |
| `allowed_http_cidrs` | list(string) | `["0.0.0.0/0"]`                   | Who can reach ALB HTTP             |
| `single_nat`         | bool         | `true`                            | Single NAT or per-AZ NAT GWs       |
| `ssm_managed`        | bool         | `false`                           | SSM role attached on EC2 servers   |

Example `terraform.tfvars`:

```hcl
project_name       = "nginx-lab"
region             = "eu-central-1"
vpc_cidr           = "10.0.0.0/16"
public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets    = ["10.0.11.0/24", "10.0.12.0/24"]
instance_type      = "t3.micro"
desired_capacity   = 2
min_size           = 2
max_size           = 3
allowed_http_cidrs = ["0.0.0.0/0"]
single_nat         = true
ssm_managed        = false
```

---

## 5) Root example (quick start)

`envs/default/main.tf` (minimal end‑to‑end):

```hcl
module "vpc" {
    source = "../..//modules/vpc"
    vpc_cidr = var.vpc_cidr
    project_name = var.project_name
    private_subnets = var.private_subnets
    public_subnets = var.public_subnets
    single_nat = var.single_nat  
}

module "web" {
    source = "../../modules/web"
    private_subnets = module.vpc.private_subnets_ids
    public_subnets = module.vpc.public_subnets_ids
    project_name = var.project_name
    vpc_id = module.vpc.vpc_id
    desired_capacity = var.desired_capacity
    min_size = var.min_size
    max_size = var.max_size
    instance_type = var.instance_type
    ssm_managed = var.ssm_managed

    depends_on = [ module.vpc ]  #NAT GW is needed to run user-data script
}

output "alb" {
    value = "http://${module.web.alb_dns}"
}
```

`envs/default/terraform.tf`:

```hcl
terraform {
  required_version = ">= 1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  #Optional for s3 remote backend
  backend "s3" {
        bucket = "s3-bucket-name"
        key = "nginx/tfstate/default/terraform.tfstate" 
        region = "eu-central-1"
        use_lockfile = true
    }
}
```

`envs/default/providers.tf`:

```hcl
provider "aws" {
  region = var.region
}
```

`envs/default/variables.tf`:

```hcl
variable "project_name"       { type = string  default = "nginx-lab" }
variable "region"             { type = string  default = "eu-central-1" }
variable "vpc_cidr"           { type = string  default = "10.0.0.0/16" }
variable "public_subnets"     { type = list(string) default = ["10.0.1.0/24","10.0.2.0/24"] }
variable "private_subnets"    { type = list(string) default = ["10.0.11.0/24","10.0.12.0/24"] }
variable "instance_type"      { type = string  default = "t3.micro" }
variable "desired_capacity"   { type = number  default = 2 }
variable "min_size"           { type = number  default = 2 }
variable "max_size"           { type = number  default = 3 }
variable "allowed_http_cidrs" { type = list(string) default = ["0.0.0.0/0"] }
variable "single_nat"         { type = bool default = true }
variable "ssm_managed"        { type = bool default = false }
```

---

## 6) Module sketches

### `modules/vpc`

Creates: VPC, subnets, IGW, NAT GW(s), route tables, associations, basic tags.

Inputs:

```hcl
variable "project_name"    { type = string }
variable "vpc_cidr"        { type = string }
variable "public_subnets"  { type = list(string) }
variable "private_subnets" { type = list(string) }
variable "private_subnets" { type = list(string) }
variable "single_nat"      { type = bool }
```

Outputs:

```hcl
output "vpc_id"             { value = aws_vpc.this.id }
output "public_subnets_ids"  { value = aws_subnet.public[*].id }
output "private_subnets_ids" { value = aws_subnet.private[*].id }
```

### `modules/web`

Creates: ALB (+ target group/listener on 80), SGs, Launch Template with **user_data** to install Nginx, ASG spread across private subnets, health checks.

Key pieces:

```hcl
# Security groups
# - alb_sg: allow 80 from allowed_http_cidrs, egress to asg_sg
# - asg_sg: allow 80 from alb_sg, egress 0.0.0.0/0

# Launch template user_data (cloud-init)
user_data = base64encode(<<-EOF
#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
EOF
)
```

Outputs:

```hcl
output "alb_dns_name" { value = "http://${aws_lb.this.dns_name}" }
```

---

## 7) Usage

From the root **environment** directory (e.g., `envs/default`):

```bash
terraform init
terraform plan -out plan.out
terraform apply plan.out

# When finished
terraform destroy
```

---

## 8) Verifying

* After `apply`, Terraform will output `alb_dns_name`.
* Open it in a browser: `http://<alb_dns_name>` → You should see the **Hello World from the instances** page.
* ALB target health should turn **healthy** after EC2s finish user‑data.

---

## 9) Clean up

Always destroy resources when done:

```bash
terraform destroy
```

Double‑check that **ALB**, **NAT**, and **EIPs** are gone to stop charges.

---

## 10) License

MIT – do what you want; attribution appreciated.
