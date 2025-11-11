data "aws_ami" "linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*kernel-6.1-x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}