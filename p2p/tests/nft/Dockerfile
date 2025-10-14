FROM docker.io/golang:1.25.1-alpine3.22 AS build
WORKDIR $GOPATH/src/go.k6.io/k6

# hadolint ignore=DL3018
RUN apk add --no-cache git && \
    go install go.k6.io/xk6/cmd/xk6@v0.20.1 && \
    xk6 build --with github.com/coreeng/xk6-prometheus@v1.0.2 --output /tmp/k6

FROM docker.io/prom/prometheus:v2.55.1 AS prometheus

FROM docker.io/alpine:3.22

# hadolint ignore=DL3018
RUN apk add --no-cache ca-certificates && \
    adduser -D -u 12345 -g 12345 k6

COPY --from=build /tmp/k6 /usr/bin/k6
COPY --from=prometheus /bin/promtool /usr/bin/promtool

USER 12345
WORKDIR /home/k6

COPY ./resources/load-testing/ /home/k6/load-testing

ENV K6_OUT=prometheus

ENTRYPOINT ["k6"]
