resource "aws_iam_user" "user" {
  name = "demo-user"
}

resource "aws_iam_user_policy" "policy" {
  name   = "demo-user-policy"
  user   = aws_iam_user.user.name
  policy = file("./user-policy.json")
}