FROM golang:1.19.2-alpine3.16 as builder

LABEL stage=gobuilder

RUN apk add --no-cache git build-base linux-headers

WORKDIR /app

# download and cache go mod
COPY ./go.* ./

RUN go env -w GO111MODULE=on && go mod download

COPY . .

RUN make build


FROM alpine:3.16


WORKDIR root

COPY --from=builder /app/build/bin/firewalld /usr/bin/firewalld


VOLUME ["/root"]

ENTRYPOINT ["firewalld"]
