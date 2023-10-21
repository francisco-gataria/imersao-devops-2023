terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.22.0"
    }
  }
}


provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "imersao-devops-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true

  tags = {
    "kubernetes.io/cluster/imersao-eks" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/imersao-eks" = "shared"
    "kubernetes.io/role/elb"            = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/imersao-eks" = "shared"
    "kubernetes.io/role/internal-elb"   = 1
  }

}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.17.2"

  cluster_name    = "imersao-eks"
  cluster_version = "1.27"


  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  cluster_endpoint_public_access  = true

  eks_managed_node_groups = {
    default = {
        min_size = 2
        max_size = 2
        desired_size = 2
        instance_types = ["t3.micro"]
    }
  }
}