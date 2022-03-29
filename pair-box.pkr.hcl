variable "user" {
  type = string
  default = "pair"
}

variable "group_id" {
  type = number
  default = 1001
}

variable "user_id" {
  type = number
  default = 1001
}

variable "api_token" {
  type = string
  description = "Your Linode API token, supplied frome env var via Make"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "linode" "pugilism" {
  image             = "linode/alpine3.15"
  image_description = "Pugilism base image"
#  image_label       = "pugilism-${local.timestamp}"
   image_label       = "pair-box"
  instance_label    = "temporary-linode-${local.timestamp}"
  instance_type     = "g6-nanode-1"
  linode_token      = var.api_token
  region            = "eu-west"
  ssh_username      = "root"
}

build {
  sources = ["source.linode.pugilism"]
  provisioner "file" {
    source = "keys"
    destination = "/tmp"
  }
  provisioner "file" {
    source = "dotfiles"
    destination = "/tmp"
  }
  provisioner "shell" {
    inline = [
      "addgroup -g ${var.group_id} ${var.user}",
      "adduser -D -G ${var.user} -u ${var.user_id} ${var.user}",
      "usermod -p '*' ${var.user}", # necessary to allow SSH
      "adduser ${var.user} wheel", # allow user to sudo
      "echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers",
      "mkdir /home/${var.user}/.ssh",
      "chown ${var.user}:${var.user} /home/${var.user}/.ssh",
      "cat /tmp/keys/*.pub > /home/${var.user}/.ssh/authorized_keys",
      "chown ${var.user}:${var.user} /home/${var.user}/.ssh/authorized_keys",
      "chmod 600 /home/${var.user}/.ssh/authorized_keys",
      "cp /tmp/dotfiles/.[^.]* /home/${var.user}",
      "chown ${var.user}:${var.user} /home/${var.user}/.??*",
      "apk update && apk add make git emacs-nox tmux nodejs npm",
      "npm install -g git-pair"
    ]
  }
  post-processor "manifest" {}
}
