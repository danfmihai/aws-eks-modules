module "eks" {
  source = "terraform-aws-modules/eks/aws"
  cluster_version           = "1.21"
  cluster_name              = "my-cluster"
  vpc_id                    = module.vpc.vpc_id
  subnets                   = [module.vpc.private_subnets[0], module.vpc.public_subnets[1]]
  cluster_create_timeout    = "25m"
  cluster_endpoint_private_access = true
  
  worker_groups = [
  { 
      name                          = "worker-group-1"
      instance_type                 = "t2.small"
      additional_userdata           = "echo foo bar"
      asg_desired_capacity          = 1
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
  },
  ]

}

resource "aws_security_group" "worker_group_mgmt_one" {
  name_prefix = "worker_group_mgmt_one"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
    ]
  }
}