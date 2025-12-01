FROM  php:fpm-alpine

# =========================
# 系统依赖
# =========================
RUN apk add --no-cache \
    freetype-dev \
    libwebp-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libxml2-dev \
    libzip-dev \
    gmp-dev \
    imagemagick \
    imagemagick-dev \
    libmemcached-dev \
    zlib-dev

# =========================
# 构建依赖（稍后删除）
# =========================
RUN apk add --no-cache --virtual .build-deps \
    ${PHPIZE_DEPS} \
    build-base \
    autoconf \
    libtool \
    git

# =========================
# 安装 PHP 扩展
# =========================

# gd
RUN docker-php-ext-configure gd \
        --with-freetype \
        --with-webp \
        --with-jpeg

# 内建扩展
RUN docker-php-ext-install -j"$(nproc)" \
        bcmath \
        exif \
        gd \
        pdo_mysql \
        soap \
        zip \
        gmp

# PECL 扩展
RUN pecl install \
        imagick \
        memcached \
        redis \
    && docker-php-ext-enable \
        imagick \
        memcached \
        redis

# =========================
# 清理构建依赖
# =========================
RUN apk del .build-deps \
    && rm -rf /tmp/pear \
    && rm -rf /var/cache/apk/*

CMD ["php-fpm"]
