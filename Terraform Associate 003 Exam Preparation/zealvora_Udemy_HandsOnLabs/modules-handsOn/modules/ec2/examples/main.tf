provider "aws" {
    region = "eu-central-1"
}

module "ec2" {
    source = "../modules/ec2"
    instance_type = "m5.large"
}