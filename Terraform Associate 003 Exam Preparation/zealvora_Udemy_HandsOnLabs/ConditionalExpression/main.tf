provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "myec2" {
  ami           = "ami-0444794b421ec32e4"
  instance_type = var.isProd && var.region == "eu-central-1" ? "t3.large" : "t3.micro"
}

output "instance_type" {
    value = aws_instance.myec2.instance_type
}