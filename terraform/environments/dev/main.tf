provider "aws" {
  region = var.region
}


# Get default VPC and SG
data "aws_vpc" "default" {
  default = true
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = data.aws_vpc.default.id
}

############
# VPC + SG #
############

module "fargate_network" {
  source               = "../../modules/network"
  name                 = "fargate"
  vpc_cidr             = "10.20.0.0/16"
  public_subnet_cidrs  = ["10.20.3.0/24", "10.20.4.0/24"]
  private_subnet_cidrs = ["10.20.1.0/24", "10.20.2.0/24"]
  availability_zones   = ["ap-south-1a", "ap-south-1b"]
  cluster_name         = "dev-cluster"
}

###############
# EC2 MODULES #
###############

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

###################
# IAM ROLES (EKS) #
###################

data "aws_iam_role" "eks_cluster_role" {
  count = var.enable_eks ? 1 : 0
  name  = "eksClusterRole"
}

data "aws_iam_role" "fargate_pod_role" {
  count = var.enable_eks ? 1 : 0
  name  = "eksFargatePodExecutionRole"
}

##################
# EKS CLUSTER    #
##################

module "eks" {
  count                = var.enable_eks ? 1 : 0
  source               = "../../modules/eks"
  cluster_name         = "my-fargate-eks"
  cluster_role_arn     = data.aws_iam_role.eks_cluster_role[0].arn
  fargate_pod_role_arn = data.aws_iam_role.fargate_pod_role[0].arn
  subnet_ids           = module.fargate_network.private_subnet_ids
  fargate_sg_id        = module.fargate_network.fargate_sg_id
}

