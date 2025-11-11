terraform {
  # backend "s3" {
  #   bucket       = "henrik-terraform-backend"
  #   key          = "nginx/tfstate/default/terraform.tfstate"
  #   region       = "eu-central-1"
  #   use_lockfile = true

  # }
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

}