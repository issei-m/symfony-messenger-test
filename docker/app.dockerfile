FROM php:7.3-fpm-alpine3.9

RUN apk upgrade --update && apk --no-cache add \
    # iconv, intl
    icu-dev \
    # xdebug
    autoconf make g++ gcc

RUN docker-php-ext-install -j$(nproc) iconv intl mbstring pdo_mysql opcache && \
  pecl install xdebug-2.7.1 && \
  docker-php-ext-enable xdebug

RUN { \
  echo 'opcache.max_accelerated_files = 20000'; \
  echo 'opcache.enable_file_override = 1'; \
  echo 'xdebug.remote_enable = 1'; \
  echo 'xdebug.max_nesting_level = 1000'; \
  echo 'xdebug.fast_shutdown = 1'; \
  echo 'xdebug.remote_host = docker.for.mac.localhost'; \
} > /usr/local/etc/php/conf.d/overrides.ini

COPY . /var/www/php
