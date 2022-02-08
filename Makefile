.PHONY: all echo clean build validate tf-shell create-box delete-box ssh

OS_USER=`whoami`
BOX_IP=`cat .box_ip | cut -f2 -d '"'`
PUBLIC_SSH_KEY=`cat ~/.ssh/id_rsa.pub`

all:	clean validate build

echo:
	@ echo "OS_USER set to $(OS_USER)"
	@ echo "BOX_IP set to $(BOX_IP)"
	@ echo "LINODE_TOKEN set to $(LINODE_TOKEN)"
	@ echo "PUBLIC_SSH_KEY set to $(PUBLIC_SSH_KEY)"
clean:
	if [ -d .terraform ]; then sudo chown -R $(OS_USER):$(OS_USER) .terraform; fi
	rm -rf .terraform
	rm -f *~ terraform.tfstate* packer-manifest.json .box_ip
	docker image prune -f

build:
	docker run -it \
	-v `pwd`:/var/app \
	-v /home/$(OS_USER)/.ssh:/tmp/.ssh \
	-w /var/app \
	hashicorp/packer:light \
	build -force -var "api_token=$(LINODE_TOKEN)" pair-box.pkr.hcl

validate:
	docker run -it \
	-v `pwd`:/var/app \
	-v /home/$(OS_USER)/.ssh:/tmp/.ssh \
	-w /var/app \
	hashicorp/packer:light \
	validate -var "api_token=$(LINODE_TOKEN)" pair-box.pkr.hcl

tf-shell:
	docker run -it \
	-v `pwd`:/var/app \
	-v /home/$(OS_USER)/.ssh:/tmp/.ssh \
	-w /var/app \
	-e LINODE_TOKEN="$(LINODE_TOKEN)" \
	--entrypoint sh \
	hashicorp/terraform:1.1.2

create-box: tf-init tf-apply tf-output

tf-init:
	docker run -it \
	-v `pwd`:/var/app \
	-v /home/$(OS_USER)/.ssh:/tmp/.ssh \
	-w /var/app \
	-e LINODE_TOKEN="$(LINODE_TOKEN)" \
	hashicorp/terraform:1.1.2 init

tf-apply:
	docker run -it \
	-v `pwd`:/var/app \
	-v /home/$(OS_USER)/.ssh:/tmp/.ssh \
	-w /var/app \
	-e LINODE_TOKEN="$(LINODE_TOKEN)" \
	hashicorp/terraform:1.1.2 apply -auto-approve \
	-var "public_ssh_key=$(PUBLIC_SSH_KEY)"

tf-output:
	docker run -it \
	-v `pwd`:/var/app \
	-v /home/$(OS_USER)/.ssh:/tmp/.ssh \
	-w /var/app \
	-e LINODE_TOKEN="$(LINODE_TOKEN)" \
	hashicorp/terraform:1.1.2 \
	output box_ip >.box_ip

delete-box:
	docker run -it \
	-v `pwd`:/var/app \
	-v /home/$(OS_USER)/.ssh:/tmp/.ssh \
	-w /var/app \
	-e LINODE_TOKEN="$(LINODE_TOKEN)" \
	hashicorp/terraform:1.1.2 destroy \
	-auto-approve -var "public_ssh_key=x"

ssh:
	ssh -A -i ~/.ssh/id_rsa pair@$(BOX_IP)
