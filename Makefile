PROJECT?=git.soma.salesforce.com/jusong-chen/godror-example
REPO?=/go/src/${PROJECT}
GOPKG_SRC_PATH?=./go_pkg_src
APP?=rana-test
PORT?=9090
BIN_HOME?=/bin

RELEASE?=0.0.1
COMMIT?=$(shell git rev-parse --short HEAD)
BUILD_TIME?=$(shell date -u '+%Y-%m-%d_%H:%M:%S')
CONTAINER_IMAGE?=${APP}
BUILD_CONTAINER?=${APP}-build

DOCKER_REGISTRY?=dva-registry.internal.salesforce.com
GOLANG_DOCKER_IMAGE?=${DOCKER_REGISTRY}/dva/golang_build
GOOS?=linux
GOARCH?=amd64

clean:
	rm -f ${APP}

test:
	go test -v -race ./...

go-build: clean
	CGO_ENABLED=1 GOOS=${GOOS} GOARCH=${GOARCH} go build \
		-ldflags "-s -w -X ${PROJECT}/version.Release=${RELEASE} \
		-X ${PROJECT}/version.Commit=${COMMIT} -X ${PROJECT}/version.BuildTime=${BUILD_TIME}" \
		-installsuffix cgo \
		-o ${APP}

docker-build: clean
	docker login $(DOCKER_REGISTRY)

	docker build -t $(BUILD_CONTAINER):$(RELEASE) -f build.Dockerfile \
		--build-arg GOLANG_DOCKER_IMAGE=$(GOLANG_DOCKER_IMAGE) \
		--build-arg APP=$(APP) \
		--build-arg REPO=$(REPO)  \
		--build-arg PROJECT=$(PROJECT) \
		--build-arg RELEASE=$(RELEASE) \
		--build-arg COMMIT=$(COMMIT) \
		--build-arg BUILD_TIME=$(BUILD_TIME) \
		.
	docker rm -f $(BUILD_CONTAINER) || true
	docker create --name $(BUILD_CONTAINER) $(BUILD_CONTAINER):$(RELEASE)
	docker cp $(BUILD_CONTAINER):$(REPO)/$(APP) .
	docker rm -f $(BUILD_CONTAINER)




run-linux: go-build
	./${APP}

go-build-container: go-build
	docker build -t $(CONTAINER_IMAGE):$(RELEASE) -f Dockerfile --build-arg APP=$(APP) --build-arg BIN_HOME=$(BIN_HOME)  .

docker-build-container: docker-build
	docker build -t $(CONTAINER_IMAGE):$(RELEASE) -f Dockerfile --build-arg APP=$(APP) --build-arg BIN_HOME=$(BIN_HOME)  .

docker-run-docker-build: docker-build-container
	docker stop $(APP):$(RELEASE) || true && docker rm $(APP):$(RELEASE) || true
	docker run -it -u 7447:7447 --name ${APP} -p ${PORT}:${PORT} --rm -e "PORT=${PORT}" $(APP):$(RELEASE) $(BIN_HOME)/$(APP)
	# docker run -it -u 7447:7447 --name ${APP} -p ${PORT}:${PORT}  -e "PORT=${PORT}" $(APP):$(RELEASE)

docker-run-go-build: go-build-container
	docker stop $(APP):$(RELEASE) || true && docker rm $(APP):$(RELEASE) || true
	docker run -it -u 7447:7447 --name ${APP} -p ${PORT}:${PORT} --rm -e "PORT=${PORT}" $(APP):$(RELEASE) $(BIN_HOME)/$(APP)
	# docker run -it -u 7447:7447 --name ${APP} -p ${PORT}:${PORT}  -e "PORT=${PORT}" $(APP):$(RELEASE)

# push: container
# 	docker push $(CONTAINER_IMAGE):$(RELEASE)
