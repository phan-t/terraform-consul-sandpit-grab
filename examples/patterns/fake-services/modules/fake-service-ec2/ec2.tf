locals {
  key_pair_private_key = file("../../../${var.deployment_id}.pem")
  datacenter_name = "${join("-", slice(split("-", var.deployment_id), 0, 2))}-aws"
}

data "aws_ami" "fake-service" {
  most_recent      = true
  owners           = ["self"]

  filter {
    name   = "name"
    values = ["fake-service-consul-envoy-ubuntu-*"]
  }

  filter {
    name   = "tag:application"
    values = ["fake-service"]
  }

  filter {
    name   = "tag:consul_version"
    values = ["${var.consul_version}+ent"]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "tag:Name"
    values = ["*private*"]
  }
}

data "aws_security_group" "ssh" {
  filter {
    name   = "tag:Name"
    values = ["${var.deployment_id}-ssh"]
  }
}

data "aws_security_group" "consul" {
  filter {
    name   = "tag:Name"
    values = ["${var.deployment_id}-consul"]
  }
}

resource "aws_instance" "fake-service" {
  ami             = data.aws_ami.fake-service.id
  instance_type   = "t3.small"
  key_name        = var.deployment_id
  subnet_id       = element(data.aws_subnets.private.ids, 1)
  security_groups = [data.aws_security_group.ssh.id, data.aws_security_group.consul.id]

  tags = {
    Name  = "${var.deployment_id}-fake-service"
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "local_file" "consul-client-config" {
  content = templatefile("../../../examples/templates/consul-client-ec2-config.hcl.tpl", {
    datacenter_name    = local.datacenter_name
    node_name          = aws_instance.fake-service.private_dns
    server_address     = var.server_address
    acl_token          = var.client_acl_token
    gossip_encrypt_key = var.gossip_encrypt_key
    })
  filename = "${path.module}/configs/client-config.hcl.tmp"
  
  depends_on = [
    aws_instance.fake-service
  ]
}

resource "local_file" "fake-service-config" {
  content = templatefile("../../../examples/templates/fake-service.config.tpl", {
    upstream_uris         = ""
    name                  = "fake-service"
    })
  filename = "${path.module}/configs/fake-service.config"
  
  depends_on = [
    aws_instance.fake-service
  ]
}

resource "local_file" "fake-service-service-register" {
  content = templatefile("../../../examples/templates/consul-service-register.json.tpl", {
    service_name          = var.service_name
    tags                  = var.service_name
    port                  = 9090
    })
  filename = "${path.module}/configs/fake-service-service-register.json.tmp"
  
  depends_on = [
    aws_instance.fake-service
  ]
}

resource "null_resource" "fake-service" {
  connection {
    host          = aws_instance.fake-service.private_dns
    user          = "ubuntu"
    agent         = false
    private_key   = local.key_pair_private_key
    bastion_host  = var.bastion_public_fqdn
  }

  provisioner "file" {
    content      = local_file.consul-client-config.content
    destination = "/tmp/client-config.hcl"
  }

  provisioner "file" {
    content      = local_file.fake-service-config.content
    destination = "/tmp/fake-service.config"
  }

  provisioner "file" {
    content      = local_file.fake-service-service-register.content
    destination = "/tmp/fake-service-service-register.json"
  }

  provisioner "file" {
    source      = "../../../consul-ent-license.hclic"
    destination = "/tmp/consul-ent-license.hclic"
  }

  provisioner "file" {
    content      = file("../../../tls/ca-cert.pem")
    destination = "/tmp/ca-cert.pem"
  }

  provisioner "file" {
    content      = tls_locally_signed_cert.client-signed-cert.cert_pem
    destination = "/tmp/client-cert.pem"
  }

  provisioner "file" {
    content      = tls_private_key.client-key.private_key_pem
    destination = "/tmp/client-key.pem"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cp /tmp/client-config.hcl /opt/consul/config/default.hcl",
      "sudo cp /tmp/fake-service.config /opt/fake-service/config/fake-service.config",
      "sudo cp /tmp/fake-service-service-register.json /opt/consul/config/fake-service-service-register.json",     
      "sudo cp /tmp/consul-ent-license.hclic /opt/consul/bin/consul-ent-license.hclic",
      "sudo cp /tmp/ca-cert.pem /opt/consul/tls/ca-cert.pem",
      "sudo cp /tmp/client-cert.pem /opt/consul/tls/client-cert.pem",
      "sudo cp /tmp/client-key.pem /opt/consul/tls/client-key.pem",
      "sudo /opt/consul/bin/run-consul --client --skip-consul-config",
      "sudo /opt/fake-service/bin/run-fake-service"
    ]
  }

  depends_on = [
    local_file.consul-client-config
  ]
}