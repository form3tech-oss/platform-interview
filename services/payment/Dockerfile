FROM golang:alpine AS builder

WORKDIR $GOPATH/src/form3tech/payment/
COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -o /go/bin/payment

FROM scratch
COPY --from=builder /go/bin/payment /go/bin/payment

ENTRYPOINT ["/go/bin/payment"]