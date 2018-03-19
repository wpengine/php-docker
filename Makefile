IMAGE       := wpengine/php
VERSIONS    := 5.6 7.0 7.1 7.2

all: tag

build: $(addprefix build-, $(VERSIONS))
build-%:
	docker build -t $(IMAGE):$* -f Dockerfile.php$* .

tag: $(addprefix tag-, $(VERSIONS))
tag-%: | build-%
	$(eval TAG := $(shell docker run $(IMAGE):$* php -v | head -n1 | cut -d " " -f 2))
	docker tag $(IMAGE):$* $(IMAGE):$(TAG)

clean:
	docker images -a | grep $(IMAGE) | awk '{print $$3}' | xargs -I% docker rmi % -f
