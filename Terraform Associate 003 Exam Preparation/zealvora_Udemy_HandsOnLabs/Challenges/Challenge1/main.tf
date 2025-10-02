provider "aws" {
  region     = "eu-central-1"
}

provider "digitalocean" {}

terraform {
  required_version = "1.10.5"
  required_providers {
    aws = {
        source  = "hashicorp/aws"
        version = "~> 6.0"
    }
    digitalocean = {
        source  = "digitalocean/digitalocean"
        version = "~> 2.0"
    }
  }
}


# resource "aws_eip" "kplabs_app_ip" {
#   vpc = true
# }

resource "aws_eip" "kplabs_app_ip" {
    domain = "vpc"
}