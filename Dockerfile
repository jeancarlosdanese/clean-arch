# Etapa de build
FROM golang:1.23.3 AS builder
WORKDIR /app
COPY . .
WORKDIR /app/cmd/ordersystem
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o /app/clean-arch .

# Instala o migrate no builder
RUN go install -tags 'mysql' github.com/golang-migrate/migrate/v4/cmd/migrate@latest

# Etapa de execução
FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/clean-arch .
COPY --from=builder /app/db/migrations ./db/migrations
COPY --from=builder /go/bin/migrate /usr/local/bin/migrate
RUN chmod +x /usr/local/bin/migrate
RUN apk add --no-cache mysql-client
RUN apk add --no-cache libc6-compat
RUN apk add --no-cache bash

COPY wait-for-it.sh /usr/local/bin/wait-for-it.sh
RUN chmod +x /usr/local/bin/wait-for-it.sh

COPY .env .

# Entry point do container
ENTRYPOINT ["bash", "-c", "/usr/local/bin/wait-for-it.sh rabbitmq:5672 -t 20 -- /usr/local/bin/migrate -path ./db/migrations -database 'mysql://root:root@tcp(mysql:3306)/orders' up && ./clean-arch"]
