variable "deployment_id" {
  description = "deployment id"
  type        = string
}

variable "route53_sandbox_prefix" {
  description = "aws route53 sandbox account prefix"
  type        = string
}

variable "bastion_public_fqdn" {
  description = "public fqdn of bastion node"
  type        =  string 
}

variable "consul_version" {
  description = "consul version"
  type        = string
}

variable "initial_acl_token" {
  description = "consul initial acl token"
  type        = string
}

variable "gossip_encrypt_key" {
  description = "consul gossip encryption key"
  type        = string
}