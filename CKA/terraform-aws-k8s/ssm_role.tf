
resource "aws_iam_role" "ssm_k8s_role" {
  name = "k8s_ssm_role"

  assume_role_policy = jsonencode({
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
})
}

resource "aws_iam_role_policy_attachment" "ssm_k8s_role_attach" {
  role       = aws_iam_role.ssm_k8s_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "ssm_k8s_profile"
  role = aws_iam_role.ssm_k8s_role.name
}