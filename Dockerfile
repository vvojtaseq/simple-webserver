FROM golang:1.24-alpine AS build

WORKDIR /app
COPY . .

RUN go mod tidy && go build -o webserver .

FROM alpine:latest
WORKDIR /root/

COPY --from=build /app/webserver .

EXPOSE 8082
CMD ["./webserver"]
