terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
    }
    random = {
      source = "hashicorp/random"
      version = "3.1.0"
    }
  }
}

provider "random" {
  # Configuration options
}

provider "linode" {
  # Configuration options
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

variable "box_name" {
  type        = string
  description = "the name of the instance to be created"
  default     = "pair-box"
}

variable "public_ssh_key" {
  type        = string
  description = "Your PUBLIC SSH key"
}

data "linode_images" "base_images" {
  filter {
    name   = "label"
    values = ["pair-box"]
  }
  filter {
    name   = "is_public"
    values = ["false"]
  }
  latest = true
}

resource "linode_instance" "pair_box" {
  label  = "pair_box"
  image  = data.linode_images.base_images.images[0].id
  region = "eu-west"
  type   = "g6-nanode-1"
  authorized_keys = [ var.public_ssh_key ] # for root access
  root_pass = random_password.password.result
}

output "box_ip" {
  value = linode_instance.pair_box.ip_address
}
