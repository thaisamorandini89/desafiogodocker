##### Stage 1 #####

FROM golang:1.15 as builder

RUN mkdir -p /app
WORKDIR /app

COPY go.mod .
COPY go.sum .

ENV GOPROXY https://proxy.golang.org,direct

RUN go mod download

COPY . .

ENV CGO_ENABLED=0

RUN GOOS=linux go build ./app.go

##### Stage 2 #####
### Alternatively to 'FROM scratch', use 'alpine':
# FROM alpine:3.13.1
FROM scratch

WORKDIR /app

COPY --from=builder /app/app .

CMD ["/app/app"]

