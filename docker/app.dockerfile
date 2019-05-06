FROM php:7.3-fpm-alpine3.9

RUN apk upgrade --update

# xdebug
RUN apk --no-cache add \
    autoconf make g++ gcc \
    && pecl install xdebug-2.7.1 \
    && docker-php-ext-enable xdebug

# iconv, intl, any other needed
RUN apk --no-cache add \
    icu-dev \
    && docker-php-ext-install -j$(nproc) \
        iconv \
        intl \
        mbstring \
        pdo_mysql \
        opcache \
        pcntl

# amqp
RUN apk --no-cache add \
    rabbitmq-c \
    rabbitmq-c-dev \
    && pecl install amqp-1.9.4 \
    && docker-php-ext-enable amqp

RUN { \
  echo 'opcache.max_accelerated_files = 20000'; \
  echo 'opcache.enable_file_override = 1'; \
  echo 'xdebug.remote_enable = 1'; \
  echo 'xdebug.max_nesting_level = 1000'; \
  echo 'xdebug.fast_shutdown = 1'; \
  echo 'xdebug.remote_host = docker.for.mac.localhost'; \
} > /usr/local/etc/php/conf.d/overrides.ini

COPY . /app

WORKDIR /app
