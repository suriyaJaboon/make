# ID Commit
BASE_TAG=$(shell git rev-parse --short HEAD)

# Image name for docker
IMAGE_NAME=techcatch/techcatch

# Application name for go packages
APP_NAME=techcatch
PATH_APP=/go/src/$(APP_NAME)

# Base golang image tag
GOLANG_TAG=1.11.2-alpine

# Build args for Dockerfile's
BUILD_BASE_ARGS=--build-arg APP_NAME=$(APP_NAME) --build-arg GOLANG_TAG=$(GOLANG_TAG)
BUILD_TEST_ARGS=--build-arg IMAGE_NAME=$(IMAGE_NAME) --build-arg BASE_TAG=$(BASE_TAG)
BUILD_ARGS=--build-arg IMAGE_NAME=$(IMAGE_NAME) --build-arg APP_NAME=$(APP_NAME) --build-arg BASE_TAG=$(BASE_TAG)

# Make
build-publish:
		@echo ":: Build publish image id-commit $(BASE_TAG)"
		docker push $(IMAGE_NAME):$(BASE_TAG)

build-base:
		@echo ":: Building base image"
		docker build --rm -f Base.Dockerfile $(BUILD_BASE_ARGS) -t $(IMAGE_NAME)-base:$(BASE_TAG) .

build-image:
		@echo ":: Build docker image id-commit $(BASE_TAG)"
		docker build --rm -f Binary.Docker $(BUILD_BASE_ARGS) -t $(IMAGE_NAME)-$(BASE_TAG):$(BASE_TAG) .

build-dependencies:
		@echo ":: Install dependencies"
		docker run --rm -v $(shell pwd):/$(PATH_APP) -w $(PATH_APP) $(IMAGE_NAME)-base:$(BASE_TAG) dep ensure -update

build-develop:

build-release:

build-prod:
		@echo ":: Buind binary TechCatch id-commit $(BASE_TAG)"
		docker run --rm -v $(shell pwd):/$(PATH_APP) -w $(PATH_APP) golang:$(GOLANG_TAG) go build -o $(PATH_APP)-$(BASE_TAG) -i -v  $(PATH_APP)/main.go

build-unit-test:
		@echo ":: Buind binary TechCatch id-commit $(BASE_TAG)"
		docker run --rm -v $(shell pwd):/go/src/$(APP_NAME) -w /go/src/$(APP_NAME) golang:$(GOLANG_TAG) go test -v ./... 

build-sonar:
		@echo ":: SonarQube by TechCatch id-commit $(BASE_TAG)"
		docker run --rm -it -v $(shell pwd):/root/src -v $(shell pwd)/sonar-project.properties:/root/sonar-scanner/conf/sonar-scanner.properties newtmitch/sonar-scanner sonar-scanner

deploy: 
		@echo ":: Deployment to server"

