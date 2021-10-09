module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_version = "1.21"
  cluster_name    = "my-cluster"
  vpc_id          = module.vpc.vpc_id
  subnets         = [module.vpc.private_subnets[0], module.vpc.public_subnets[1]]

  node_groups = {
    public = {
      subnets          = [module.vpc.public_subnets[1]]
      desired_capacity = 1
      max_capacity     = 5
      min_capacity     = 1

      instance_type = "t2.small"
      k8s_labels = {
        Environment = "public"
      }
    }

    private = {
      subnets          = [module.vpc.private_subnets[0]]
      desired_capacity = 1
      max_capacity     = 5
      min_capacity     = 1

      instance_type = "t2.small"
      k8s_labels = {
        Environment = "private"
      }
    }
  }


}

