FROM golang:1.23-alpine AS builder
RUN apk add --no-cache git
WORKDIR /workspace
ENV GOPROXY=direct
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN go mod tidy
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o controller ./cmd/controller

FROM alpine:latest as final
WORKDIR /app
RUN adduser -D -u 65532 nonroot
RUN mkdir -p bin
COPY --from=builder /workspace/controller ./bin/controller
RUN chmod +x ./bin/controller
RUN chown -R nonroot:nonroot /app
USER 65532:65532
ENTRYPOINT ["./bin/controller"]