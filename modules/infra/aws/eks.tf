module "eks" {
  source                          = "terraform-aws-modules/eks/aws"
  version                         = "18.26.3"

  cluster_name                    = var.deployment_id
  cluster_version                 = var.eks_cluster_version
  vpc_id                          = module.vpc.vpc_id
  subnet_ids                      = module.vpc.private_subnets
  cluster_endpoint_private_access = true
  cluster_service_ipv4_cidr       = var.eks_cluster_service_cidr

  eks_managed_node_group_defaults = { 
  }

  eks_managed_node_groups = {
    "default_node_group" = {
      min_size               = 1
      max_size               = 3
      desired_size           = var.eks_worker_desired_capacity

      instance_types         = ["${var.eks_worker_instance_type}"]
      capacity_type          = "SPOT"
      key_name               = module.key_pair.key_pair_name
      vpc_security_group_ids = [module.sg-consul.security_group_id]
    }
  }

  cluster_security_group_additional_rules = {
    ingress_kubernetes_endpoint_api = {
      description                = "kubernetes endpoint api"
      protocol                   = "tcp"
      from_port                  = 443
      to_port                    = 443
      type                       = "ingress"
      cidr_blocks                = ["${module.vpc.vpc_cidr_block}"]
    }
  }
}
    
resource "null_resource" "kubeconfig" {

  provisioner "local-exec" {
    command = "aws eks --region ${var.region} update-kubeconfig --name ${module.eks.cluster_id}"
  }

  depends_on = [
    module.eks
  ]
}