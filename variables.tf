// generic variables

variable "deployment_name" {
  description = "deployment name, used to prefix resources"
  type        = string
  default     = "grab-sandpit"
}

// amazon web services (aws) variables

variable "aws_region" {
  description = "aws region"
  type        = string
}

variable "aws_vpc_cidr" {
  description = "aws vpc cidr"
  type        = string
  default     = "10.200.0.0/16"
}

variable "aws_private_subnets" {
  description = "aws private subnets"
  type        = list
  default     = ["10.200.20.0/24", "10.200.21.0/24", "10.200.22.0/24"]
}

variable "aws_public_subnets" {
  description = "aws public subnets"
  type        = list
  default     = ["10.200.10.0/24", "10.200.11.0/24", "10.200.12.0/24"]
}

variable "aws_route53_sandbox_prefix" {
  description = "aws route53 sandbox account prefix"
  type        = string
}

variable "aws_eks_cluster_version" {
  description = "aws eks cluster version"
  type        = string
  default     = "1.22"
}

variable "aws_eks_cluster_service_cidr" {
  description = "aws eks cluster service cidr"
  type        = string
  default     = "172.20.0.0/18"
}

variable "aws_eks_worker_instance_type" {
  description = "aws eks ec2 worker node instance type"
  type        = string
  default     = "m5.large"
}

variable "aws_eks_worker_desired_capacity" {
  description = "aws eks desired worker capacity in the autoscaling group"
  type        = number
  default     = 3
}

// hashicorp self-managed consul variables

variable "consul_server_version" {
  description = "consul server version"
  type        = string
  default     = "1.10.12"
}

variable "consul_ent_license" {
  description = "consul enterprise license"
  type        = string
  default     = ""
}

// hashicorp self-managed consul client on kubernetes variables

variable "consul_client_version" {
  description = "consul client version"
  type        = string
  default     = "1.10.12"
}

variable "consul_helm_chart_version" {
  type        = string
  description = "consul helm chart version"
  default     = "0.38.0"
}

variable "consul_k8s_version" {
  description = "consul-k8s version"
  type        = string
  default     = "0.38.0"
}

variable "envoy_version" {
  description = "envoy version"
  type        = string
  default     = "1.16.5"
}

variable "consul_replicas" {
  description = "number of consul replicas on kubernetes"
  type        = number
  default     = 1
}
