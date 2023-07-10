packer {
  required_version = ">= 1.5.4"
}

variable "aws_region" {
  type    = string
  default = "ap-southeast-2"
}

variable "consul_version" {
  type    = string
  default = "1.16.0+ent"
}

variable "consul_download_url" {
  type    = string
  default = "${env("CONSUL_DOWNLOAD_URL")}"
}

variable "envoy_version" {
  type    = string
  default = "1.26.2"
}

variable "application_name" {
  type    = string
  default = "fake-service"
}

variable "fake_service_version" {
  type    = string
  default = "0.25.2"
}

variable "fake_service_download_url" {
  type    = string
  default = "${env("FAKESERVICE_DOWNLOAD_URL")}"
}

data "amazon-ami" "ubuntu20" {
  filters = {
    architecture                       = "x86_64"
    "block-device-mapping.volume-type" = "gp2"
    name                               = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
    root-device-type                   = "ebs"
    virtualization-type                = "hvm"
  }
  most_recent = true
  owners      = ["099720109477"]
  region      = "${var.aws_region}"
}

source "amazon-ebs" "ubuntu20-ami" {
  ami_description             = "An Ubuntu 20.04 AMI that has Consul and Envoy installed."
  ami_name                    = "fake-service-consul-envoy-ubuntu-${formatdate("YYYYMMDDhhmm", timestamp())}"
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  region                      = "${var.aws_region}"
  source_ami                  = "${data.amazon-ami.ubuntu20.id}"
  ssh_username                = "ubuntu"
  tags = {
    application     = "${var.application_name}"
    consul_version  = "${var.consul_version}"
    envoy_version   = "${var.envoy_version}"
    owner           = "tphan@hashicorp.com"
    packer_source   = "https://github.com/phan-t/terraform-consul-sandpit-grab/blob/master/examples/amis/fake-service/fake-service-consul-envoy.pkr.hcl"
  }
}

build {
  sources = ["source.amazon-ebs.ubuntu20-ami"]

  provisioner "shell" {
    inline = ["mkdir -p /tmp/terraform-consul-sandpit-grab/"]
  }

  provisioner "shell" {
    inline       = ["git clone https://github.com/phan-t/terraform-consul-sandpit-grab.git /tmp/terraform-consul-sandpit-grab"]
    pause_before = "30s"
  }

  provisioner "shell" {
    inline       = ["if test -n \"${var.consul_download_url}\"; then", "/tmp/terraform-consul-sandpit-grab/examples/amis/consul/scripts/install-consul --download-url ${var.consul_download_url};", "else", "/tmp/terraform-consul-sandpit-grab/examples/amis/consul/scripts/install-consul --version ${var.consul_version};", "fi"]
    pause_before = "30s"
  }
  
  provisioner "shell" {
    inline       = ["/tmp/terraform-consul-sandpit-grab/examples/amis/consul/scripts/setup-systemd-resolved"]
    pause_before = "30s"
  }

  provisioner "shell" {
    inline       = ["sudo curl -L https://func-e.io/install.sh | bash -s -- -b /tmp", "/tmp/func-e use ${var.envoy_version}", "sudo cp ~/.func-e/versions/${var.envoy_version}/bin/envoy /usr/local/bin/"]
    pause_before = "30s"
  } 

  provisioner "shell" {
    inline       = ["if test -n \"${var.fake_service_download_url}\"; then", "/tmp/terraform-consul-sandpit-grab/examples/amis/fake-service/scripts/install-fake-service --download-url ${var.fake_service_download_url};", "else", "/tmp/terraform-consul-sandpit-grab/examples/amis/fake-service/scripts/install-fake-service --version ${var.fake_service_version};", "fi"]
    pause_before = "30s"
  }

  provisioner "shell" {
    inline       = ["sudo cp /tmp/terraform-consul-sandpit-grab/examples/amis/fake-service/scripts/run-consul-envoy /opt/consul/bin/run-consul-envoy"]
    pause_before = "30s"
  }

}