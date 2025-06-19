module "eks-security-groups" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "17.24.0"
  cluster_name    = local.cluster_name 
  cluster_version = "1.29"
  subnets         = data.aws_subnets.vpc_subnets.ids

  tags = {
    Environment = "training"
  }

  vpc_id = aws_default_vpc.default_vpc.id

  workers_group_defaults = {
    root_volume_type = "gp2"
  }

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "t2.small"
      additional_userdata           = "echo foo bar"
      asg_desired_capacity          = 2
      additional_security_group_ids = [aws_security_group.nice-cluster-group-1.id]
      public_ip = true
    },
    {
      name                          = "worker-group-2"
      instance_type                 = "t2.medium"
      additional_userdata           = "echo foo bar"
      additional_security_group_ids = [aws_security_group.nice-cluster-group-2.id]
      asg_desired_capacity          = 1
      public_ip = true
    },
    {
      name                          = "worker-group-3"
      instance_type                 = "t2.large"
      additional_userdata           = "echo foo bar"
      additional_security_group_ids = [aws_security_group.all_worker_mgmt.id]
      asg_desired_capacity          = 1
      public_ip = true
    }
  ]
}

# Existing security groups for management (already defined in your config)

resource "aws_security_group" "nice-cluster-group-1" {
  name_prefix = "nice-cluster-group-1"
  vpc_id      = aws_default_vpc.default_vpc.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
    ]
  }
}

resource "aws_security_group" "nice-cluster-group-2" {
  name_prefix = "nice-cluster-group-2"
  vpc_id      = aws_default_vpc.default_vpc.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "192.168.0.0/16",
    ]
  }
}

resource "aws_security_group" "all_worker_mgmt" {
  name_prefix = "all_worker_management"
  vpc_id      = aws_default_vpc.default_vpc.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
      "172.16.0.0/12",
      "192.168.0.0/16",
    ]
  }
}
