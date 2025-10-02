resource "aws_security_group" "security_group_payment_app" {
  name        = "payment_app"
  description = "Application Security Group"
  depends_on  = [aws_eip.example]

  # Below ingress allows HTTPS  from DEV VPC
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.dev_vpc_cidr]
  }

  # Below ingress allows APIs access from DEV VPC

  ingress {
    from_port   = var.api_dev_port
    to_port     = var.api_dev_port
    protocol    = "tcp"
    cidr_blocks = [var.dev_vpc_cidr]
  }

  # Below ingress allows APIs access from Prod App Public IP.

  ingress {
    from_port   = var.api_prod_port
    to_port     = var.api_prod_port
    protocol    = "tcp"
    cidr_blocks = ["${aws_eip.example.public_ip}/32"]
  }
  egress {
    from_port   = var.splunk
    to_port     = var.splunk
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_eip" "example" {
  domain = "vpc"
}