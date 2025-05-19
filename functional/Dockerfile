FROM golang:1.24-alpine3.21

WORKDIR /opt/app

COPY ./functional/go.mod ./functional/go.sum ./
RUN go mod download

COPY ./functional/ ./
RUN go test -c -o ./functional.test

CMD ["./functional.test"]
