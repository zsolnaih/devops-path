provider "aws" {
  region = "eu-central-1"
}

resource "aws_security_group" "name" {
  name = "test-sg"
}