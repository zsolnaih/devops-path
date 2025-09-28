provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "myec2" {
  ami           = "ami-0444794b421ec32e4"
  instance_type = "t3.micro"
  tags = {
    Name = "My-First-Ec2"
  }
}
