provider "aws" {
  region = "eu-central-1"
}

resource "aws_eip" "pub_ip" {
    domain = "vpc"
}

output "pub_ip_addr" {
    value = aws_eip.pub_ip.public_ip
  
}