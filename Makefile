.PHONY: all echo clean build validate create-box delete-box ssh

OS_USER=`whoami`

all:	clean validate build

echo:
	@ echo "OS_USER set to $(OS_USER)"
	@ echo "Scaleway access key set to $(SCW_SECRET_KEY)"
	@ echo "Scaleway secret key set to $(SCW_ACCESS_KEY)"
	@ echo "Scaleway project ID set to $(SCW_DEFAULT_PROJECT_ID)"

clean:
	rm -f *~
	docker image prune -f

build:
	docker run -it \
	-v `pwd`:/var/app \
	-v /home/$(OS_USER)/.ssh:/tmp/.ssh \
	-w /var/app \
	-e SCW_SECRET_KEY \
	-e SCW_ACCESS_KEY \
	-e SCW_DEFAULT_PROJECT_ID \
	hashicorp/packer:light build pair-box.pkr.hcl

validate:
	docker run -it \
	-v `pwd`:/var/app \
	-v /home/$(OS_USER)/.ssh:/tmp/.ssh \
	-w /var/app \
	-e SCW_SECRET_KEY \
	-e SCW_ACCESS_KEY \
	-e SCW_DEFAULT_PROJECT_ID \
	hashicorp/packer:light validate pair-box.pkr.hcl

create-box:
	@ echo "Not yet implemented"

delete-box:
	@ echo "Not yet implemented"

ssh:
	@ echo "Not yet implemented"
