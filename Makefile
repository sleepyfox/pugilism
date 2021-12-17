.PHONY: all echo clean build-packer-image build-box-image validate

IMAGE=packer
VERSION=light
DOCKER_USER=sleepyfox
UID=`id -u`
GID=`id -g`
OS_USER=`whoami`

all:	clean validate

echo:
	@ echo "DOCKER_USER set to $(DOCKER_USER)"
	@ echo "IMAGE set to $(IMAGE)"
	@ echo "VERSION set to $(VERSION)"
	@ echo "UID set to $(UID)"
	@ echo "GID set to $(GID)"
	@ echo "OS_USER set to $(OS_USER)"

clean:
	rm -f *~
	docker image prune -f

build-packer-image: Dockerfile
	docker build \
	--build-arg USER=$(OS_USER) \
	-t $(DOCKER_USER)/$(IMAGE):$(VERSION) .

build-box-image:
	docker run -it \
	-v `pwd`:/var/app \
	-w /var/app \
	-u $(OS_USER) \
	$(DOCKER_USER)/$(IMAGE):$(VERSION) build pair-box.pkr.hcl

validate:
	docker run -it \
	-v `pwd`:/var/app \
	-v /home/$(OS_USER)/.ssh:/tmp/.ssh \
	-w /var/app \
	-u $(OS_USER) \
	-e SCW_SECRET_KEY \
	-e SCW_ACCESS_KEY \
	$(DOCKER_USER)/$(IMAGE):$(VERSION) validate pair-box.pkr.hcl
