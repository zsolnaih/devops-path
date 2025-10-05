variable "public_subnets" {
  description = "Public subnet CIDRs "
  type    = list(string)
}
variable "private_subnets" {
  description = "Private subnet CIDRs"
  type    = list(string)
}
variable "instance_type" {
  description = "EC2 type for ASG "
  type    = string
}
variable "desired_capacity" {
  description = "ASG desired capacity "
  type    = number
}
variable "min_size" {
  description = "ASG min size "
  type    = number
}
variable "max_size" {
  description = "ASG max size"
  type    = number
}
variable "allowed_http_cidrs" {
  description = "Who can reach ALB HTTP"
  type    = list(string)
}
variable "vpc_id" {
  description = "VPC CIDR block"
  type    = string
}
variable "project_name" { 
  description = "Name prefix for tags and resources"
  type = string 
}
variable "ssm_managed" {
  description = "SSM role attached on EC2 servers"
  type =  bool
}