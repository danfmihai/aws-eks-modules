module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "17.20.0"
  cluster_version = "1.21"
  cluster_name    = "my-cluster"
  vpc_id          = module.vpc.vpc_id
  subnets         = [module.vpc.private_subnets[0], module.vpc.public_subnets[1]]

  node_groups = {
    public = {
      subnets          = [llocal.vpc.public_subnets[1]]
      desired_capacity = 1
      max_capacity     = 5
      min_capacity     = 1

      instance_type = "t2.small"
      k8s_labels = {
        Environment = "public"
      }
    }

    private = {
      subnets          = [llocal.vpc.private_subnets[0]]
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


locals {
  region       = data.terraform_remote_state.bootstrap.outputs.region
  cluster_name = data.terraform_remote_state.bootstrap.outputs.cluster_name
  vpc          = data.terraform_remote_state.bootstrap.outputs.vpc
}