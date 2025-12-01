FROM  php:fpm-alpine
  
RUN   apk add --update --no-cache ${PHPIZE_DEPS} build-base autoconf git imagemagick imagemagick-dev libgomp libmemcached-dev libtool zlib-dev
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
RUN   pecl install memcached
RUN   pecl install redis
RUN   docker-php-ext-enable memcached redis
RUN   apk del ${PHPIZE_DEPS} git libtool
RUN   rm -rf /tmp/pear

RUN   apk add --update --no-cache freetype-dev libwebp-dev libjpeg-turbo-dev libpng-dev libxml2-dev libzip-dev
RUN   docker-php-ext-configure gd --with-freetype --with-webp --with-jpeg
RUN   docker-php-ext-install -j$(nproc) bcmath
RUN   docker-php-ext-install -j$(nproc) exif
RUN   docker-php-ext-install -j$(nproc) gd
RUN   docker-php-ext-install -j$(nproc) opcache
RUN   docker-php-ext-install -j$(nproc) pdo_mysql
RUN   docker-php-ext-install -j$(nproc) soap
RUN   docker-php-ext-install -j$(nproc) zip

RUN   apk add --update --no-cache gmp-dev
RUN   docker-php-ext-configure gmp
RUN   docker-php-ext-install -j$(nproc) gmp

RUN   apk add --update --no-cache bash


CMD   ["php-fpm"]
