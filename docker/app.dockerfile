ARG PHP_VERSION="7.3"
ARG ALPINE_VERSION="3.9"


### Runtime base
FROM php:${PHP_VERSION}-cli-alpine${ALPINE_VERSION} AS runtime-base

RUN apk --no-cache add \
    autoconf make g++ gcc \
    && pecl install xdebug-2.7.1

RUN apk upgrade --update && apk --no-cache add \
    icu-dev \
    autoconf \
    make \
    g++ \
    gcc \
    rabbitmq-c \
    rabbitmq-c-dev
RUN docker-php-ext-install -j$(nproc) \
    iconv \
    intl \
    mbstring \
    pdo_mysql \
    opcache \
    pcntl \
    && pecl install amqp-1.9.4 \
    && docker-php-ext-enable amqp

RUN { \
  echo 'opcache.max_accelerated_files = 20000'; \
  echo 'opcache.enable_file_override = 1'; \
} > /usr/local/etc/php/conf.d/overrides.ini


### Debug runtime
FROM runtime-base AS app-develop

RUN docker-php-ext-enable xdebug

RUN { \
  echo 'xdebug.remote_enable = 1'; \
  echo 'xdebug.max_nesting_level = 1000'; \
  echo 'xdebug.fast_shutdown = 1'; \
  echo 'xdebug.remote_host = docker.for.mac.localhost'; \
} >> /usr/local/etc/php/conf.d/overrides.ini

COPY . /app
WORKDIR /app


### Debug runtime
FROM php:${PHP_VERSION}-fpm-alpine${ALPINE_VERSION} AS app-develop-fpm

COPY --from=app-develop /usr/lib /usr/lib
COPY --from=app-develop /usr/local/etc/php /usr/local/etc/php
COPY --from=app-develop /usr/local/lib/php /usr/local/lib/php
COPY --from=app-develop /app /app
