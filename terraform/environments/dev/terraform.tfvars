ami      = "ami-0583c2579d6458f46"
key_name = "MumbaiKeyPair"

enable_eks = true
enable_ec2 = true

instances = {
  # nexus = {
  #   az            = "ap-south-1a"
  #   tag           = "1a"
  #   name          = "nexus-server"
  #   instance_type = "t2.micro"
  #   extra_tags = {
  #     Name        = "nexus"
  #     Environment = "dev"
  #   }
  # }

  # docker = {
  #   az            = "ap-south-1a"
  #   tag           = "1a"
  #   name          = "docker-server"
  #   instance_type = "t2.micro"
  #   extra_tags = {
  #     Name        = "docker"
  #     Environment = "dev"
  #   }
  # }

  automationHost = {
    az            = "ap-south-1a"
    tag           = "fargate-private-subnet-1"
    name          = "eks-automation-host"
    instance_type = "t2.micro"
    extra_tags = {
      Name        = "automation-host"
      Environment = "dev"
    }
  }
}
