variable "region" {
  default = "eu-central-1"
}

variable "tags" {
  type = list
  default = ["first-ec2","second-ec2"]
}

variable "ami" {
  type = map
  default = {
    "us-east-1" = "ami-08a0d1e16fc3f61ea"
    "us-west-2" = "ami-0b20a6f09484773af"
    "eu-central-1" = "ami-0444794b421ec32e4"
  }
}
