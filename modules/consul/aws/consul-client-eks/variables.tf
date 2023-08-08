variable "deployment_id" {
  description = "deployment id"
  type        = string
}

variable "consul_version" {
  description = "consul version"
  type        = string
}

variable "consul_k8s_version" {
  description = "consul-k8s version"
  type        = string
}

variable "consul_helm_chart_version" {
  type        = string
  description = "consul helm chart version"
}

variable "server_address" {
  description = "private endpoint address"
  type        = string
}

variable "client_acl_token" {
  description = "client acl token"
  type        = string
}

variable "gossip_encrypt_key" {
  description = "gossip encryption key"
  type        = string
}

variable "replicas" {
  description = "number of consul replicas on kubernetes"
  type        = number
}

variable "kubernetes_api_endpoint" {
  description = "kubernetes api endpoint"
  type        = string
}

variable "ca_key" {
  description = "ca key"
  type        = string
}

variable "ca_cert" {
  description = "ca cert"
  type        = string
}