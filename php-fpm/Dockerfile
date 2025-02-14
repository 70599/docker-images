FROM  php:fpm-alpine
  
RUN   apk add --update --no-cache ${PHPIZE_DEPS} git imagemagick-dev libgomp libmemcached-dev libtool zlib-dev
RUN   git clone https://github.com/Imagick/imagick
RUN   pwd
RUN   cd imagick
RUN   pwd
RUN   tree ./
RUN   ls -l
RUN   ls -l imagick/config.m4
RUN   phpize && ./configure
RUN   make
RUN   make install
RUN   pecl install memcached
RUN   pecl install redis
RUN   docker-php-ext-enable imagick memcached redis
RUN   apk del ${PHPIZE_DEPS} git libtool
RUN   rm -rf /tmp/pear

RUN   apk add --update --no-cache freetype-dev libwebp-dev libjpeg-turbo-dev libpng-dev libxml2-dev libzip-dev
RUN   docker-php-ext-configure gd --with-freetype --with-webp --with-jpeg
RUN   docker-php-ext-install -j$(nproc) bcmath exif gd mysqli opcache pdo_mysql soap zip

RUN   apk add --update --no-cache gmp-dev
RUN   docker-php-ext-configure gmp
RUN   docker-php-ext-install -j$(nproc) gmp

RUN   apk add --update --no-cache bash


CMD   ["php-fpm"]
