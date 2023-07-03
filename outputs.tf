// generic outputs

output "deployment_id" {
  description = "Deployment identifier"
  value       = local.deployment_id
}

// amazon web services (aws) outputs

output "aws_region" {
  description = "AWS region"
  value       = var.aws_region
}

output "aws_bastion_public_fqdn" {
  description = "AWS bastion node public fqdn"
  value       = module.infra-aws.bastion_public_fqdn
}

// hashicorp self-managed consul outputs

output "consul_ui_url" {
  description = "Consul ui url"
  value       = "https://${module.consul-server.ui_fqdn}"
}

output "consul_client_version" {
  description = "Consul version"
  value       = var.consul_client_version
}

output "consul_server_private_ip" {
  description = "Consul server private ip"
  value       = module.consul-server.private_ip
}

output "consul_intial_acl_token" {
  description = "Consul initial acl token"
  value       = random_uuid.consul-initial-acl-token.result
  sensitive   = true
}

output "consul_gossip_encrypt_key" {
  description = "Consul gossip encrypt key"
  value       = random_id.consul-gossip-encrypt-key.b64_std
  sensitive   = true
}