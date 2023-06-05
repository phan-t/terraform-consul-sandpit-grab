variable "deployment_id" {
  description = "deployment id"
  type        = string
}

variable "region" {
  description = "aws region"
  type        = string
}

variable "vpc_cidr" {
  description = "vpc cidr"
  type        = string
}

variable "public_subnets" {
  description = "public subnets"
  type        = list
}

variable "private_subnets" {
  description = "private subnets"
  type        = list
}

variable "eks_cluster_version" {
  description = "eks cluster version"
  type        = string
}

variable "eks_cluster_service_cidr" {
  description = "eks cluster service cidr"
  type        = string
}

variable "eks_worker_instance_type" {
  description = "eks worker nodes instance type"
  type        = string
}

variable "eks_worker_desired_capacity" {
  description = "eks worker nodes desired capacity"
  type        = number
}