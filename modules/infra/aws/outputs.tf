output "vpc_id" {
  description = "vpc id"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "public subnet ids"
  value       = module.vpc.public_subnets
}

output "private_subnet_ids" {
  description = "private subnet ids"
  value       = module.vpc.private_subnets
}

output "key_pair_name" {
  description = "key pair name"
  value       = module.key_pair.key_pair_name
}   

output "security_group_ssh_id" {
  description = "security group ssh id"
  value       = module.sg-ssh.security_group_id
}

output "security_group_consul_id" {
  description = "security group consul id"
  value       = module.sg-consul.security_group_id
}

output "bastion_public_fqdn" {
  description = "public fqdn of bastion"
  value       = aws_instance.bastion.public_dns
}

output "eks_cluster_id" {
  description = "eks cluster id"
  value       = module.eks.cluster_id
}