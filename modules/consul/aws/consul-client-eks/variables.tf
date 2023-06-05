variable "deployment_id" {
  description = "deployment id"
  type        = string
}

variable "cluster_name" {
  description = "cluster name"
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

variable "envoy_version" {
  description = "envoy version"
  type        = string
}

variable "server_address" {
  description = "private endpoint address"
  type        = string
}

variable "acl_token" {
  description = "acl token"
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