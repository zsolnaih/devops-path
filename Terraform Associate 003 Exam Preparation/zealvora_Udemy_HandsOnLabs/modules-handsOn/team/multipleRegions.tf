provider "aws" {
  region = "eu-central-1"
}

provider "aws" {
  alias  = "us_east"
  region = "us-east-1"
}

provider "aws" {
  alias  = "us_west"
  region = "us-west-1"
}

provider "aws" {
  alias  = "ap-south"
  region = "ap-south-1"
}

provider "aws" {
  alias  = "eu-west"
  region = "eu-west-1"
}

locals {
  region_providers = {
    "ap-south-1" = aws.ap-south
    "us-west-1"  = aws.us_west
    "us-east-1"  = aws.us_east
    "eu-west-1"  = aws.eu-west
  }
}

variable "regions" {
  type    = list(string)
  default = null

}

module "sg_multi" {
  for_each = var.regions == null ? {} : { for r in var.regions : r => r }

  source  = "./modules/sg"
  sg_name = "example-${each.key}"

  providers = {
    aws = lookup(local.region_providers, each.key, aws)
  }
}