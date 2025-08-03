variable "cluster_name" {
  type = string
}

variable "cluster_role_arn" {
  type = string
}

variable "fargate_pod_role_arn" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "fargate_sg_id" {
  type        = string
  description = "Security Group ID for Fargate profile"
}
