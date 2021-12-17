variable "user" {
  type = string
  default = "groot"
}

source "scaleway" "pugilism" {
  image = "ubuntu_focal"
  zone = "nl-ams-1"
  commercial_type = "STARDUST1-S"
  ssh_username = "${var.user}"
  ssh_private_key_file = "/tmp/.ssh/id_rsa"
  project_id = "92c1a072-cc1d-4f80-b211-3e042943a32d"
}

build {
  sources = ["source.scaleway.pugilism"]
}

#scw instance server create type= zone=nl-ams-1 image= root-volume=l:10G name=scw-suspicious-fermi ip=new project-id=92c1a072-cc1d-4f80-b211-3e042943a32d
