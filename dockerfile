FROM golang:1.11.13-alpine3.10 AS build-env
RUN apk add --no-cache git gcc musl-dev
RUN apk update && apk add ca-certificates curl
RUN mkdir -p  /src/server
RUN mkdir -p  /src/utils
COPY utils /src/utils
COPY server /src/server
COPY go.mod /src/
COPY go.sum /src/
RUN cd /src/ && go mod download && cd /src/server && go build -o server

# final stage
FROM alpine
RUN mkdir /app
WORKDIR /app
COPY --from=build-env /src/server/server /app/
CMD ["/app/server"]
