variable "user" {
  type = string
  default = "pair"
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
      "apt-get -q update && apt-get install -yq make emacs-nox",
      "groupadd -g 1000 ${var.user}",
      "useradd -g 1000 -u 1000 ${var.user}",
      "cp /tmp/keys/*.pub /home/${var.user}/.ssh",
      "cp /tmp/dotfiles/* /home/${var.user}"
    ]
  }
}

#scw instance server create type= zone=nl-ams-1 image= root-volume=l:10G name=scw-suspicious-fermi ip=new project-id=92c1a072-cc1d-4f80-b211-3e042943a32d
