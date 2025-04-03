ARG base_image=alpine
ARG VERSION=latest

FROM golang:1.24-alpine AS builder
ARG VERSION

RUN apk --no-cache add git

WORKDIR /app
COPY ./go.* ./
RUN go mod download -x

COPY . ./

RUN echo "${VERSION}" > /app/version && \
  GOBIN=/app/bin go install -ldflags="-w -s -X main.version=${VERSION}" -v ./cmd/...

FROM ${base_image} AS foo

COPY --from=builder /app/bin/foo /app/bin/foo
COPY --from=builder /app/version /app/version

CMD ["/app/bin/foo"]

FROM ${base_image} AS bar

COPY --from=builder /app/bin/bar /app/bin/bar
COPY --from=builder /app/version /app/version

CMD ["/app/bin/bar"]