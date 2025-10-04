
variable "public_subnets" {
  type    = list(string)
}
variable "private_subnets" {
  type    = list(string)
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
variable "vpc_id" {
  type    = string
}
variable "project_name" { 
  type = string 
}