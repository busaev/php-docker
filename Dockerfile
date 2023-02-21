ARG PHP_VERSION="8.2"

FROM php:${PHP_VERSION}-fpm-bullseye AS php_prod

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

COPY docker/php/php-fpm.d/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf

RUN mkdir -p /var/run/php

WORKDIR /srv/app

FROM php_prod AS php_dev
