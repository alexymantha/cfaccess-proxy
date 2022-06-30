FROM golang:1.18 as builder
ARG MOD
ENV MOD ${MOD:-readonly}
RUN mkdir /build
COPY . /build/
WORKDIR /build
RUN echo "go mod flag: $MOD" && CGO_ENABLED=0 GOOS=linux go build -mod=$MOD -a -installsuffix cgo -ldflags '-extldflags "-static"' -o main .

FROM alpine:20220328
WORKDIR /app
COPY --from=builder /build/main /app
ENTRYPOINT ["/bin/sh", "-c", "./main"]
