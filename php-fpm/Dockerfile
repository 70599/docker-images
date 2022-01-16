FROM  php:fpm-alpine

RUN   apk add --update --no-cache ${PHPIZE_DEPS} git imagemagick-dev libgomp libmemcached-dev libtool libuuid zlib-dev \
      && git clone https://github.com/Imagick/imagick \
      && cd imagick \
      && phpize && ./configure \
      && make && make install \
      && pecl install memcached \
      && pecl install redis \
      && pecl install uuid \
      && docker-php-ext-enable imagick memcached redis uuid \
      && apk del ${PHPIZE_DEPS} git libtool \
      && rm -rf /tmp/pear

RUN   apk add --update --no-cache freetype-dev libwebp-dev libjpeg-turbo-dev libpng-dev libxml2-dev libzip-dev \
      && docker-php-ext-configure gd --with-freetype --with-webp --with-jpeg \
      && docker-php-ext-install -j$(nproc) bcmath exif gd mysqli opcache pdo_mysql soap zip

RUN   apk add --update --no-cache gmp-dev \
      && docker-php-ext-configure gmp \
      && docker-php-ext-install -j$(nproc) gmp

RUN   apk add --update --no-cache bash


CMD   ["php-fpm"]
