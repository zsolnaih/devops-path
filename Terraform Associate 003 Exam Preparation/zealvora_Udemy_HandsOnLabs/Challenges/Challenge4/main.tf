data "aws_caller_identity" "current" {}

resource "aws_iam_user" "lb" {
  name = "admin-user-${data.aws_caller_identity.current.account_id}"
  path = "/"
}

data "aws_iam_users" "users" {
    depends_on = [ aws_iam_user.lb ]
}

output "users" {
    value = tolist(data.aws_iam_users.users.names)
}

output "user_count" {
    value = length(data.aws_iam_users.users.names)
}