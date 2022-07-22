FROM golang:alpine AS builder
WORKDIR $GOPATH/src/form3tech/account/
ENV CGO_ENABLED=0
COPY . .
ARG TARGETOS
ARG TARGETARCH
RUN GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -ldflags="-w -s" -o /go/bin/account

FROM scratch
COPY --from=builder /go/bin/account /go/bin/account

ENTRYPOINT ["/go/bin/account"]