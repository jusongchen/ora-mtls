ARG GOLANG_DOCKER_IMAGE
FROM ${GOLANG_DOCKER_IMAGE} AS build-env

ARG APP
ARG REPO
ARG GOOS=linux
ARG GOARCH=amd64
ARG PROJECT
ARG RELEASE
ARG COMMIT
ARG BUILD_TIME
ENV GO111MODULE=on

WORKDIR $REPO 
COPY *.go ./
COPY go.mod ./

# RUN go env

RUN cd $REPO && CGO_ENABLED=1 GOOS=${GOOS} GOARCH=${GOARCH} go build \
    -ldflags "-s -w -X ${PROJECT}/version.Release=${RELEASE} \
    -X ${PROJECT}/version.Commit=${COMMIT} -X ${PROJECT}/version.BuildTime=${BUILD_TIME}" \
    -installsuffix cgo \
    -o ${APP}

