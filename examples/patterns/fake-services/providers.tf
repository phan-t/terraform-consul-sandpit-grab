terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.21.0"
    }
    consul = {
      source  = "hashicorp/consul"
      version = "~> 2.16.2"
    }
  }
}

provider "aws" {
  region = data.terraform_remote_state.tcm.outputs.aws_region
}