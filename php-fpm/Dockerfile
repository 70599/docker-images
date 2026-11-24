FROM  php:fpm-alpine
  
RUN   apk add --update --no-cache ${PHPIZE_DEPS} build-base autoconf git imagemagick imagemagick-dev libgomp libmemcached-dev libtool oniguruma-dev zlib-dev
# RUN   git clone https://github.com/Imagick/imagick
# RUN   pwd
# RUN   cd imagick && pwd && phpize && ./configure && make && make install
RUN   set -ex \
      && git clone https://github.com/imagick/imagick \
      && ( \
          cd imagick \
          && phpize \
          && ./configure \
          && make -j "$(nproc)" \
          && make install \
      ) \
      && docker-php-ext-enable imagick
# Memcached
RUN   set -ex \
      && git clone https://github.com/php-memcached-dev/php-memcached.git \
      && cd php-memcached \
      && phpize \
      && ./configure \
      && make -j "$(nproc)" \
      && make install \
      && cd .. \
      && rm -rf php-memcached

# Redis
RUN   set -ex \
      && git clone https://github.com/phpredis/phpredis.git \
      && cd phpredis \
      && phpize \
      && ./configure \
      && make -j "$(nproc)" \
      && make install \
      && cd .. \
      && rm -rf phpredis

RUN   docker-php-ext-install mbstring
RUN   docker-php-ext-enable mbstring memcached redis
RUN   apk del ${PHPIZE_DEPS} git libtool oniguruma-dev
RUN   rm -rf /tmp/pear

RUN   apk add --update --no-cache freetype-dev libwebp-dev libjpeg-turbo-dev libpng-dev libxml2-dev libzip-dev
RUN   docker-php-ext-configure gd --with-freetype --with-webp --with-jpeg
RUN   docker-php-ext-install -j$(nproc) bcmath exif gd mysqli pdo_mysql soap zip

RUN   apk add --update --no-cache gmp-dev
RUN   docker-php-ext-configure gmp
RUN   docker-php-ext-install -j$(nproc) gmp

RUN   apk add --update --no-cache bash


CMD   ["php-fpm"]
