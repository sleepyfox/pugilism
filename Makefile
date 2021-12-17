.PHONY: echo build validate

IMAGE=hashicorp/packer
VERSION=light

echo:
	@ echo "DOCKER_USER set to $(DOCKER_USER)"
	@ echo "IMAGE set to $(IMAGE)"
	@ echo "VERSION set to $(VERSION)"
	@ echo "UID set to $(UID)"
	@ echo "GID set to $(GID)"
	@ echo "OS_USER set to $(OS_USER)"

build:
	docker run -it \
	-v `pwd`:/var/app \
	-w /var/app \
	$(IMAGE):$(VERSION) build pair-box.pkr.hcl

validate:
	docker run -it \
	-v `pwd`:/var/app \
	-w /var/app \
	$(IMAGE):$(VERSION) validate pair-box.pkr.hcl
