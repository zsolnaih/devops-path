variable "ami-latest" {
    default = "ami-0444794"
}

variable "instance_config" {
  type = map
  default = {
    instance1 = { instance_type = "t2.micro", ami = "ami-0444794b421ec32e4" }
    instance2 = { instance_type = "t2.small", ami = "latest" }
  }
}
