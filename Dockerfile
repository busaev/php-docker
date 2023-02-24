ARG PHP_VERSION="8.2"
ARG COMPOSER_VERSION=latest
ARG COMPOSER_ALLOW_SUPERUSER=1

################
FROM composer:$COMPOSER_VERSION AS composer

################
FROM php:${PHP_VERSION}-fpm-bullseye AS php_prod

ARG AMQP_VERSION=1.11.0
ARG PHPREDIS_VERSION=5.3.7

ARG FPM_PORT

RUN apt update && apt install -y  \
    librabbitmq-dev \
    libxml2-dev \
    libzip-dev \
    libpq-dev \
    libxslt-dev \
    libicu-dev \
    libpng-dev \
    wget \
   && rm -rf /var/lib/apt/lists/* \
   && docker-php-ext-install -j$(nproc) \
    soap \
    pdo_pgsql \
    xsl \
    intl \
    gd \
    zip \
    iconv

RUN mkdir -p /usr/src/php/ext/redis; \
    wget -qO- https://github.com/phpredis/phpredis/archive/refs/tags/${PHPREDIS_VERSION}.tar.gz | tar xvz -C "/usr/src/php/ext/redis" --strip 1; \
    docker-php-ext-install redis \
    && rm -f ${PHPREDIS_VERSION}.tar.gz

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

COPY docker/php/php-fpm.d/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY docker/php/php-fpm.d/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf
COPY docker/php/php-fpm.d/10_opcache.ini  /usr/local/etc/php/conf.d/10-opcache.ini

RUN sed -i "s/FPM_PORT/${FPM_PORT}/g" /usr/local/etc/php-fpm.d/www.conf

RUN touch /env_prod
RUN usermod -u 1000 www-data
WORKDIR /srv/app

################
FROM php_prod AS php_dev

ARG XDEBUG_VERSION=3.2.0

RUN mkdir -p /usr/src/php/ext/xdebug; \
    wget -qO- https://github.com/xdebug/xdebug/archive/refs/tags/${XDEBUG_VERSION}.tar.gz | tar xvz -C "/usr/src/php/ext/xdebug" --strip 1; \
    docker-php-ext-install xdebug \
    && rm -f ${XDEBUG_VERSION}.tar.gz \

RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
COPY docker/php/php-fpm.d/20_xdebug.ini  /usr/local/etc/php/conf.d/20-xdebug.ini

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN rm -f /env_prod && touch /env_dev
#WORKDIR /srv/app
