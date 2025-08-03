variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "name" {
  type = string
}

variable "eks_vpc_id" {
  description = "VPC ID to fetch subnet for EC2"
  type        = string
}


variable "subnet_tag" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "extra_tags" {
  type    = map(string)
  default = {}
}


