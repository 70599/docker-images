FROM alpine as builder

COPY build.sh /

RUN apk add --update --no-cache jq upx && /bin/sh build.sh


FROM alpine

COPY --from=builder /tmp/caddy /usr/bin/caddy

ENTRYPOINT [ "/usr/bin/caddy", "run" ]

CMD ["--config", "/etc/caddy/Caddyfile"]
