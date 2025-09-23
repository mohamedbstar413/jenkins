variable "vpc_cidr" {
    type = string
}
variable "subnet_cidr" {
    type = string
}

variable "ssh_port" {
    type = number
    default = 22
}