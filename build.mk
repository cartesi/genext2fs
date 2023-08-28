IMG ?= cartesi/genext2fs:main
CP_FROM ?= genext2fs.deb
CP_TO   ?= .

ifneq ($(BUILD_PLATFORM),)
DOCKER_PLATFORM=--platform $(BUILD_PLATFORM)
endif

all: image copy
image:
	docker buildx build --load $(DOCKER_PLATFORM) -t $(IMG) -f Dockerfile .
copy:
	ID=`docker create $(DOCKER_PLATFORM) $(IMG)` && \
	   docker cp $$ID:/usr/src/genext2fs/$(CP_FROM) $(CP_TO) && \
	   docker rm $$ID
