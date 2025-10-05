variable "project_name" {
  type    = string
}
variable "region" {
  type    = string
  default = "eu-central-1"
}
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
variable "public_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}
variable "private_subnets" {
  type    = list(string)
  default = ["10.0.11.0/24", "10.0.12.0/24"]
}
variable "instance_type" {
  type    = string
  default = "t3.micro"
}
variable "desired_capacity" {
  type    = number
  default = 2
}
variable "min_size" {
  type    = number
  default = 2
}
variable "max_size" {
  type    = number
  default = 3
}
variable "allowed_http_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}
variable "single_nat" {
  type    = bool
  default = true
}
variable "ssm_managed" {
  type    = bool
  default = false
}