.PHONY: all echo clean build validate

OS_USER=`whoami`

all:	clean validate build

echo:
	@ echo "OS_USER set to $(OS_USER)"

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
	hashicorp/packer:light build pair-box.pkr.hcl

validate:
	docker run -it \
	-v `pwd`:/var/app \
	-v /home/$(OS_USER)/.ssh:/tmp/.ssh \
	-w /var/app \
	-e SCW_SECRET_KEY \
	-e SCW_ACCESS_KEY \
	hashicorp/packer:light validate pair-box.pkr.hcl
