variable "deployment_id" {
  description = "deployment id"
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

variable "server_address" {
  description = "private endpoint address"
  type        = string
}

variable "client_acl_token" {
  description = "consul initial acl token"
  type        = string
}

variable "gossip_encrypt_key" {
  description = "consul gossip encryption key"
  type        = string
}

variable "service_name" {
  description = "service name"
  type        = string
}