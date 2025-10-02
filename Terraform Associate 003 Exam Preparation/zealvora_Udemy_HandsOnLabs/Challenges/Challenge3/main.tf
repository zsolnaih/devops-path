resource "aws_instance" "name" {
    for_each = var.instance_config
    instance_type = each.value.instance_type
    ami = each.value.ami == "latest" ? var.ami-latest : each.value.ami
}