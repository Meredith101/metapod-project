provider "aws" {
  region = var.aws_region
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "17.24.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  subnets         = data.aws_subnets.vpc_subnets.ids
  vpc_id          = aws_default_vpc.default_vpc.id

  tags = {
    Environment = var.environment
  }

  workers_group_defaults = {
    root_volume_type = var.root_volume_type
  }

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "t2.small"
      additional_userdata           = "echo foo bar"
      asg_desired_capacity          = 2
      additional_security_group_ids = [aws_security_group.nice_cluster_group_1.id]
      public_ip                     = true
    },
    {
      name                          = "worker-group-2"
      instance_type                 = "t2.medium"
      additional_userdata           = "echo foo bar"
      asg_desired_capacity          = 1
      additional_security_group_ids = [aws_security_group.nice_cluster_group_2.id]
      public_ip                     = true
    }
  ]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
