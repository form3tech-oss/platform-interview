FROM golang:alpine AS builder

WORKDIR $GOPATH/src/form3tech/gateway/
COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -o /go/bin/gateway

FROM scratch
COPY --from=builder /go/bin/gateway /go/bin/gateway

ENTRYPOINT ["/go/bin/gateway"]