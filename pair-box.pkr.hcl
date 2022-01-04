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

source "scaleway" "pugilism" {
  image = "ubuntu_focal"
  zone = "nl-ams-1"
  commercial_type = "STARDUST1-S"
  ssh_username = "root"
  ssh_private_key_file = "/tmp/.ssh/id_rsa"
  project_id = "92c1a072-cc1d-4f80-b211-3e042943a32d"
}

build {
  sources = ["source.scaleway.pugilism"]
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
      "DEBIAN_FRONTEND=noninteractive apt-get -q update && apt-get install -yq make emacs-nox",
      "groupadd -g ${var.group_id} ${var.user}",
      "useradd -g ${var.group_id} -u ${var.user_id} -m -s /bin/bash ${var.user} ",
      "mkdir /home/${var.user}/.ssh",
      "chown ${var.user}:${var.user} /home/${var.user}/.ssh",
      "cat /tmp/keys/*.pub > /home/${var.user}/.ssh/authorized_keys",
      "chmod 600 /home/${var.user}/.ssh/authorized_keys",
      "cp /tmp/dotfiles/.[^.]* /home/${var.user}"
    ]
  }
  post-processor "manifest" {}
}

#scw instance server create type= zone=nl-ams-1 image= root-volume=l:10G name=scw-suspicious-fermi ip=new project-id=92c1a072-cc1d-4f80-b211-3e042943a32d
