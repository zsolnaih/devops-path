provider "aws" {
  region = "eu-central-1"
}

locals {
  instance_type = {
    default = "t2.nano"
    dev = "t2.micro"
    prod = "t3.micro"
  }
}


resource "aws_instance" "myec2" {
  ami           = "ami-0444794b421ec32e4"
  instance_type = local.instance_type[terraform.workspace]
  tags = {
    Name = "ec2-${terraform.workspace}"
  }
}
