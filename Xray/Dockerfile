FROM alpine

ARG  VER=
ENV  VER ${VER}

COPY init.sh /init.sh
COPY config.yaml /etc/xray/config.yaml

RUN  set -ex \
  && apk add --update --no-cache curl \
  && chmod +x /init.sh \
  && /init.sh \
  && apk del ca-certificates nghttp2-libs libcurl curl \
  && rm -rf /init.sh

VOLUME /etc/xray
CMD    ["/usr/bin/xray", "run", "-config", "/etc/xray/config.yaml"]
