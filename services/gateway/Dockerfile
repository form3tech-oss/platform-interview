FROM golang:alpine AS builder
WORKDIR $GOPATH/src/form3tech/gateway/
ENV CGO_ENABLED=0
COPY . .
ARG TARGETOS
ARG TARGETARCH
RUN GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -ldflags="-w -s" -o /go/bin/gateway

FROM scratch
COPY --from=builder /go/bin/gateway /go/bin/gateway

ENTRYPOINT ["/go/bin/gateway"]