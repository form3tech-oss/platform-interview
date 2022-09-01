FROM golang:alpine AS builder

WORKDIR $GOPATH/src/form3tech/account/
COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -o /go/bin/account

FROM scratch
COPY --from=builder /go/bin/account /go/bin/account

ENTRYPOINT ["/go/bin/account"]