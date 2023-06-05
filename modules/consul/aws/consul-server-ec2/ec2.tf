locals {
  key_pair_private_key = file("${path.root}/${var.deployment_id}.pem")
  datacenter_name = "${join("-", slice(split("-", var.deployment_id), 0, 2))}-aws"
}

data "aws_ami" "consul" {
  most_recent      = true
  owners           = ["self"]

  filter {
    name   = "name"
    values = ["consul-ubuntu-*"]
  }

  filter {
    name   = "tag:application"
    values = ["consul"]
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

resource "aws_instance" "consul-server" {
  ami             = data.aws_ami.consul.id
  instance_type   = "t3.small"
  key_name        = var.deployment_id
  subnet_id       = element(data.aws_subnets.private.ids, 1)
  security_groups = [data.aws_security_group.ssh.id, data.aws_security_group.consul.id]

  tags = {
    Name  = "${var.deployment_id}-consul-server"
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "local_file" "consul-server-config" {
  content = templatefile("${path.root}/examples/templates/consul-server-ec2-config.hcl.tpl", {
    datacenter_name       = local.datacenter_name
    quorum_size           = 1
    node_name             = aws_instance.consul-server.private_dns
    initial_acl_token     = var.initial_acl_token
    gossip_encrypt_key    = var.gossip_encrypt_key
    })
  filename = "${path.module}/configs/server-config.hcl.tmp"
  
  depends_on = [
    aws_instance.consul-server
  ]
}

resource "null_resource" "consul-server-config" {
  connection {
    host          = aws_instance.consul-server.private_dns
    user          = "ubuntu"
    agent         = false
    private_key   = local.key_pair_private_key
    bastion_host  = var.bastion_public_fqdn
  }

  provisioner "file" {
    content      = local_file.consul-server-config.content
    destination = "/tmp/server-config.hcl"
  }

  provisioner "file" {
    source      = "${path.root}/consul-ent-license.hclic"
    destination = "/tmp/consul-ent-license.hclic"
  }

  provisioner "file" {
    content      = tls_self_signed_cert.ca-cert.cert_pem
    destination = "/tmp/ca-cert.pem"
  }

  provisioner "file" {
    content      = tls_locally_signed_cert.server-signed-cert.cert_pem
    destination = "/tmp/server-cert.pem"
  }

  provisioner "file" {
    content      = tls_private_key.server-key.private_key_pem
    destination = "/tmp/server-key.pem"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cp /tmp/server-config.hcl /opt/consul/config/default.hcl",
      "sudo cp /tmp/consul-ent-license.hclic /opt/consul/bin/consul-ent-license.hclic",
      "sudo cp /tmp/ca-cert.pem /opt/consul/tls/ca-cert.pem",
      "sudo cp /tmp/server-cert.pem /opt/consul/tls/server-cert.pem",
      "sudo cp /tmp/server-key.pem /opt/consul/tls/server-key.pem",
      "sudo /opt/consul/bin/run-consul --server --skip-consul-config"
    ]
  }

  depends_on = [
    local_file.consul-server-config
  ]
}