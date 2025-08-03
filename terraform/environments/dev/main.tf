provider "aws" {
  region = var.region
}

# Default VPC + SG
data "aws_vpc" "default" {
  default = true
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = data.aws_vpc.default.id
}

# EC2 Instances (enabled by flag)
module "ec2_instances" {
  for_each          = var.enable_ec2 ? var.instances : {}
  source            = "../../modules/ec2"
  ami               = var.ami
  instance_type     = each.value.instance_type
  name              = each.value.name
  subnet_tag        = each.value.tag
  security_group_id = data.aws_security_group.default.id
  key_name          = var.key_name
  extra_tags        = each.value.extra_tags
}

# EKS Cluster (optional toggle)
data "aws_iam_role" "eks_cluster_role" {
  count = var.enable_eks ? 1 : 0
  name  = "eksClusterRole"
}

data "aws_iam_role" "fargate_pod_role" {
  count = var.enable_eks ? 1 : 0
  name  = "eksFargatePodExecutionRole"
}

data "aws_subnets" "all" {
  count = var.enable_eks ? 1 : 0
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}


module "eks" {
  count                = var.enable_eks ? 1 : 0
  source               = "../../modules/eks"
  cluster_name         = "my-fargate-eks"
  cluster_role_arn     = data.aws_iam_role.eks_cluster_role[0].arn
  fargate_pod_role_arn = data.aws_iam_role.fargate_pod_role[0].arn
  subnet_ids           = data.aws_subnets.all[0].ids

}
