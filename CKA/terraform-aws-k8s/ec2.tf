resource "aws_instance" "cp" {
  ami           = data.aws_ami.linux.id
  instance_type = "t3.small"
  subnet_id     = aws_subnet.public_subnets[0].id
  vpc_security_group_ids = [aws_security_group.cp.id]
  user_data_base64 = filebase64("./ec2-user-data-cp.sh")
  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name
  tags = {
    Name = "k8s ControlPlane"
  }
  lifecycle {
    ignore_changes = [ ami ]
  }
}

resource "aws_instance" "node" {
  count                   = var.node_count
  ami                     = data.aws_ami.linux.id
  instance_type           = "t3.micro"
  subnet_id               = aws_subnet.public_subnets[0].id
  user_data_base64        = filebase64("./ec2-user-data-node.sh")
  vpc_security_group_ids  = [aws_security_group.node.id]
  iam_instance_profile    = aws_iam_instance_profile.ssm_profile.name
  tags = {
    Name = "k8s node-${count.index+1}"
  }
  lifecycle {
    ignore_changes = [ ami ]
  }
}