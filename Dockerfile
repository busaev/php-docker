ARG PHP_VERSION="8.2"

FROM php:${PHP_VERSION}-fpm-bullseye AS php_prod

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

COPY docker/php/php-fpm/app.conf /usr/local/etc/php-fpm.d/app.conf

RUN mkdir -p /var/run/php

COPY ./docker/php/entrypoint.sh /etc/entrypoint.sh
RUN chmod +x /etc/entrypoint.sh

WORKDIR /srv/app

ENTRYPOINT ["/etc/entrypoint.sh"]

FROM php_prod AS php_dev
