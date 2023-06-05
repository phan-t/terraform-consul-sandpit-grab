module "sg-ssh" {
  source = "terraform-aws-modules/security-group/aws"
  version     = "4.9.0"

  name        = "${var.deployment_id}-ssh"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      rule        = "ssh-tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      rule        = "ssh-tcp"
      cidr_blocks = "${module.vpc.vpc_cidr_block}"
    }
  ]
}

module "sg-consul" {
  source = "terraform-aws-modules/security-group/aws"
  version     = "4.9.0"

  name        = "${var.deployment_id}-consul"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 8300
      to_port     = 8302
      protocol    = "tcp"
      description = "consul-rpc-lan-wan-serf-gosspip-tcp"
      cidr_blocks = "${module.vpc.vpc_cidr_block}"
    },
    {
      from_port   = 8300
      to_port     = 8302
      protocol    = "udp"
      description = "consul-lan-wan-serf-gosspip-udp"
      cidr_blocks = "${module.vpc.vpc_cidr_block}"
    },
    {
      from_port   = 8500
      to_port     = 8502
      protocol    = "tcp"
      description = "consul-http-https-api-tcp"
      cidr_blocks = "${module.vpc.vpc_cidr_block}"
    },
    {
      from_port   = 8600
      to_port     = 8600
      protocol    = "tcp"
      description = "consul-dns-tcp"
      cidr_blocks = "${module.vpc.vpc_cidr_block}"
    },
    {
      from_port   = 8600
      to_port     = 8600
      protocol    = "udp"
      description = "consul-dns-udp"
      cidr_blocks = "${module.vpc.vpc_cidr_block}"
    },
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "consul-connect-injector-tcp"
      cidr_blocks = "${module.vpc.vpc_cidr_block}"
    },
    {
      from_port   = 20000
      to_port     = 21255
      protocol    = "tcp"
      description = "consul-connect-envoy-tcp"
      cidr_blocks = "${module.vpc.vpc_cidr_block}"
    },
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "any-any"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

module "sg-consul-ui-lb" {
  source = "terraform-aws-modules/security-group/aws"
  version     = "4.9.0"

  name        = "${var.deployment_id}-consul-ui-lb"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "consul-https-api-tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 8501
      to_port     = 8501
      protocol    = "tcp"
      description = "consul-https-api-tcp"
      cidr_blocks = "${module.vpc.vpc_cidr_block}"
    }
  ]
}
