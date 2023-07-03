locals {
  deployment_id = lower("${var.deployment_name}-${random_string.suffix.result}")
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

resource "random_uuid" "consul-initial-acl-token" { }

resource "random_id" "consul-gossip-encrypt-key" {
  byte_length = 32
}

resource "local_file" "consul-ent-license" {
  content  = var.consul_ent_license
  filename = "${path.root}/consul-ent-license.hclic"
}

// amazon web services (aws) infrastructure

module "infra-aws" {
  source  = "./modules/infra/aws"
  
  deployment_id               = local.deployment_id
  region                      = var.aws_region
  vpc_cidr                    = var.aws_vpc_cidr
  public_subnets              = var.aws_public_subnets
  private_subnets             = var.aws_private_subnets
  eks_cluster_version         = var.aws_eks_cluster_version
  eks_cluster_service_cidr    = var.aws_eks_cluster_service_cidr
  eks_worker_instance_type    = var.aws_eks_worker_instance_type
  eks_worker_desired_capacity = var.aws_eks_worker_desired_capacity
}

// consul server on aws ec2

module "consul-server" {
  source = "./modules/consul/aws/consul-server-ec2"

  deployment_id            = local.deployment_id
  route53_sandbox_prefix   = var.aws_route53_sandbox_prefix
  bastion_public_fqdn      = module.infra-aws.bastion_public_fqdn
  consul_version           = var.consul_server_version
  initial_acl_token        = random_uuid.consul-initial-acl-token.result
  gossip_encrypt_key       = random_id.consul-gossip-encrypt-key.b64_std

  depends_on = [
    module.infra-aws
  ]
}

// consul client (default partition) on aws eks

module "consul-client-eks" {
  source    = "./modules/consul/aws/consul-client-eks"

  deployment_id             = local.deployment_id
  cluster_name              = "cauldron"
  consul_version            = var.consul_client_version
  consul_helm_chart_version = var.consul_helm_chart_version
  consul_k8s_version        = var.consul_k8s_version
  envoy_version             = var.envoy_version
  server_address            = module.consul-server.private_ip
  acl_token                 = random_uuid.consul-initial-acl-token.result
  gossip_encrypt_key        = random_id.consul-gossip-encrypt-key.b64_std
  replicas                  = var.consul_replicas
  
  depends_on = [
    module.consul-server
  ]
}