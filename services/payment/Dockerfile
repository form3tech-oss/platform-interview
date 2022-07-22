FROM golang:alpine AS builder
WORKDIR $GOPATH/src/form3tech/payment/
ENV CGO_ENABLED=0
COPY . .
ARG TARGETOS
ARG TARGETARCH
RUN GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -ldflags="-w -s" -o /go/bin/payment

FROM scratch
COPY --from=builder /go/bin/payment /go/bin/payment

ENTRYPOINT ["/go/bin/payment"]