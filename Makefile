.PHONY: all echo clean build validate tf-shell create-box delete-box ssh

OS_USER=`whoami`
BOX_IP=`cat .box_ip | cut -f2 -d '"'`

all:	clean validate build

echo:
	@ echo "OS_USER set to $(OS_USER)"
	@ echo "BOX_IP set to $(BOX_IP)"
	@ echo "Scaleway access key set to $(SCW_SECRET_KEY)"
	@ echo "Scaleway secret key set to $(SCW_ACCESS_KEY)"
	@ echo "Scaleway project ID set to $(SCW_DEFAULT_PROJECT_ID)"

clean:
	rm -f *~ .terraform terraform.tfstate* packer-manifest.json
	docker image prune -f

build:
	docker run -it \
	-v `pwd`:/var/app \
	-v /home/$(OS_USER)/.ssh:/tmp/.ssh \
	-w /var/app \
	-e SCW_SECRET_KEY \
	-e SCW_ACCESS_KEY \
	-e SCW_DEFAULT_PROJECT_ID \
	hashicorp/packer:light \
	build -var "project_id=$(SCW_DEFAULT_PROJECT_ID)" pair-box.pkr.hcl

validate:
	docker run -it \
	-v `pwd`:/var/app \
	-v /home/$(OS_USER)/.ssh:/tmp/.ssh \
	-w /var/app \
	-e SCW_SECRET_KEY \
	-e SCW_ACCESS_KEY \
	-e SCW_DEFAULT_PROJECT_ID \
	hashicorp/packer:light \
	validate -var "project_id=$(SCW_DEFAULT_PROJECT_ID)" pair-box.pkr.hcl

tf-shell:
	docker run -it \
	-v `pwd`:/var/app \
	-v /home/$(OS_USER)/.ssh:/tmp/.ssh \
	-w /var/app \
	-e SCW_SECRET_KEY \
	-e SCW_ACCESS_KEY \
	-e SCW_DEFAULT_PROJECT_ID \
	--entrypoint sh \
	hashicorp/terraform:1.1.2

create-box: tf-init tf-apply tf-output

tf-init:
	docker run -it \
	-v `pwd`:/var/app \
	-v /home/$(OS_USER)/.ssh:/tmp/.ssh \
	-w /var/app \
	-e SCW_SECRET_KEY \
	-e SCW_ACCESS_KEY \
	-e SCW_DEFAULT_PROJECT_ID \
	hashicorp/terraform:1.1.2 \
	init

tf-apply:
	docker run -it \
	-v `pwd`:/var/app \
	-v /home/$(OS_USER)/.ssh:/tmp/.ssh \
	-w /var/app \
	-e SCW_SECRET_KEY \
	-e SCW_ACCESS_KEY \
	-e SCW_DEFAULT_PROJECT_ID \
	hashicorp/terraform:1.1.2 \
	apply -var "project_id=$(SCW_DEFAULT_PROJECT_ID)" create-box.tf

tf-output:
	docker run -it \
	-v `pwd`:/var/app \
	-v /home/$(OS_USER)/.ssh:/tmp/.ssh \
	-w /var/app \
	-e SCW_SECRET_KEY \
	-e SCW_ACCESS_KEY \
	-e SCW_DEFAULT_PROJECT_ID \
	hashicorp/terraform:1.1.2 \
	output box_ip >.box_ip

delete-box:
	@ echo "Not yet implemented"

ssh:
	ssh -vi ~/.ssh/id_rsa pair@$(BOX_IP)
