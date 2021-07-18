FROM alpine AS builder

ENV  BUILD_PATH '/tmp/build'
ENV  MODULE_PATH '/usr/lib/nginx/modules'
ENV  PCRE_VERSION 8.44
ENV  ZLIB_VERSION 1.2.11

RUN  apk --update upgrade \
     && apk add --no-cache --virtual .build-deps \
        curl \
        gcc \
        gd-dev \
        geoip-dev \
        gnupg \
        jq \
        libc-dev \
        libxslt-dev \
        linux-headers \
        make \
        openssl-dev \
        pcre-dev \
        perl-dev \
        zlib-dev \
     && apk add --no-cache --virtual .brotli-build-deps \
        autoconf \
        automake \
        cmake \
        g++ \
        git \
        go \
        libtool \
        patch \
        perl \
     && [ -e ${BUILD_PATH} ] || mkdir -p ${BUILD_PATH} \
     && cd ${BUILD_PATH} \
     && wget -qO- https://ftp.pcre.org/pub/pcre/pcre-${PCRE_VERSION}.tar.gz | tar zxvf - \
     && wget -qO- http://zlib.net/zlib-${ZLIB_VERSION}.tar.gz | tar zxvf - \
     && cd zlib-${ZLIB_VERSION} \
     && NGINX_VER="$(curl -sL https://api.github.com/repos/nginx/nginx/tags | jq -r '.[0].name')" \
     && git clone --depth=1 --recursive --shallow-submodules https://github.com/google/ngx_brotli \
     && git clone --depth=1 --recursive https://github.com/nginx/njs \
     && git clone --depth=1 --recursive https://github.com/AirisX/nginx_cookie_flag_module \
     && git clone --depth=1 --recursive https://github.com/cloudflare/quiche \
     && git clone --depth=1 https://github.com/kn007/patch patches \
     && wget -qO- https://github.com/nginx/nginx/archive/refs/tags/${NGINX_VER}.tar.gz | tar zxvf - \
     && cd nginx-${NGINX_VER} \
     # && patch -p01 < ../patches/nginx.patch \
     && patch -p01 < ../patches/nginx_with_quic.patch \
     && patch -p01 < ../patches/Enable_BoringSSL_OCSP.patch \
     && ./auto/configure \
        --build="quiche-$(git --git-dir=../quiche/.git rev-parse --short HEAD) pcre-${PCRE_VERSION} zlib-${ZLIB_VERSION} ngx_brotli-$(git --git-dir=../ngx_brotli/.git rev-parse --short HEAD) njs-$(git --git-dir=../njs/.git rev-parse --short HEAD) nginx_cookie_flag_module-$(git --git-dir=../nginx_cookie_flag_module/.git rev-parse --short HEAD)" \
        --prefix=/etc/nginx \
        --sbin-path=/usr/sbin/nginx \
        --modules-path=${MODULE_PATH} \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --pid-path=/var/run/nginx.pid \
        --lock-path=/var/run/nginx.lock \
        --http-client-body-temp-path=/var/cache/nginx/client_temp \
        --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
        --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
        --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
        --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
        --user=nginx \
        --group=nginx \
        --with-pcre=../pcre-${PCRE_VERSION} \
        --with-pcre-jit \
        --with-zlib=../zlib-${ZLIB_VERSION} \
        --with-http_ssl_module \
        --with-http_realip_module \
        --with-http_addition_module \
        --with-http_sub_module \
        --with-http_dav_module \
        --with-http_flv_module \
        --with-http_mp4_module \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_random_index_module \
        --with-http_secure_link_module \
        --with-http_stub_status_module \
        --with-http_auth_request_module \
        --with-http_xslt_module=dynamic \
        --with-http_image_filter_module=dynamic \
        --with-http_geoip_module=dynamic \
        --with-http_perl_module=dynamic \
        --with-threads \
        --with-stream \
        --with-stream_ssl_module \
        --with-stream_ssl_preread_module \
        --with-stream_realip_module \
        --with-stream_geoip_module=dynamic \
        --with-http_slice_module \
        --with-mail \
        --with-mail_ssl_module \
        --with-compat \
        --with-file-aio \
        --with-http_v2_module \
        --with-http_v3_module \
        --with-openssl=../quiche/deps/boringssl \
        --with-quiche=../quiche \
        --add-module=../ngx_brotli \
        --add-module=../njs/nginx \
        --add-module=../nginx_cookie_flag_module \
        --with-cc-opt=-Wno-error \
     && make -j$(getconf _NPROCESSORS_ONLN) \
     && make install \
     && install -m755 objs/ngx_http_xslt_filter_module.so ${MODULE_PATH}/ngx_http_xslt_filter_module.so \
     && install -m755 objs/ngx_http_image_filter_module.so ${MODULE_PATH}/ngx_http_image_filter_module.so \
     && install -m755 objs/ngx_http_geoip_module.so ${MODULE_PATH}/ngx_http_geoip_module.so \
     && install -m755 objs/ngx_http_perl_module.so ${MODULE_PATH}/ngx_http_perl_module.so \
     && install -m755 objs/ngx_stream_geoip_module.so ${MODULE_PATH}/ngx_stream_geoip_module.so \
     && apk add --no-cache --virtual .gettext gettext \
     && mv /usr/bin/envsubst /tmp/ \
     \
     && runDeps="$( \
     scanelf --needed --nobanner /usr/sbin/nginx /usr/lib/nginx/modules/*.so /tmp/envsubst \
     | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
     | sort -u \
     | xargs -r apk info --installed \
     | sort -u \
     )" \
     && apk add --no-cache --virtual .nginx-rundeps $runDeps \
     && apk del .build-deps \
     && apk del .brotli-build-deps \
     && apk del .gettext \
     && mv /tmp/envsubst /usr/local/bin/

RUN apk add openssl \
    && openssl req -x509 -newkey rsa:4096 -nodes -keyout /etc/ssl/private/localhost.key -out /etc/ssl/localhost.pem -days 365 -sha256 -subj '/CN=localhost'

FROM alpine

COPY --from=builder /usr/sbin/nginx /usr/sbin/
COPY --from=builder /usr/lib/nginx /usr/lib/
COPY --from=builder /etc/nginx /etc/
COPY --from=builder /usr/local/bin/envsubst /usr/local/bin/
COPY --from=builder /etc/ssl/private/localhost.key /etc/ssl/private/
COPY --from=builder /etc/ssl/localhost.pem /etc/ssl/

RUN  apk add --no-cache \
         pcre \
         libgcc \
         libintl \
     && addgroup -S nginx \
     && adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G nginx nginx \
     && mkdir -p /var/log/nginx \
     && touch /var/log/nginx/{access,error}.log \
     && chown nginx: /var/log/nginx/{access,error}.log

STOPSIGNAL SIGTERM

CMD  ["nginx", "-g", "daemon off;"]
