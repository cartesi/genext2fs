IMG ?= cartesi/genext2fs:main
ifneq ($(BUILD_PLATFORM),)
DOCKER_PLATFORM=--platform $(BUILD_PLATFORM)
endif

all: image copy
copy: genext2fs.deb

image:
	docker buildx build --load -t $(IMG) -f Dockerifle .
genext2fs.deb:
	ID=`docker create $(DOCKER_PLATFORM) $(IMG)` && \
	   docker cp $$ID:/usr/src/genext2fs/genext2fs.deb . && \
	   docker rm $$ID
