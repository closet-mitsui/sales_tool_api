FROM php:8.1.18-fpm

COPY --from=composer:2.5.5 /usr/bin/composer /usr/bin/composer

# 上記で動かない場合は公式からダウンロード
# RUN curl -sS https://getcomposer.org/installer | php -- --version=2.5\
#     && mv composer.phar /usr/local/bin/composer

RUN apt-get -y update \
    && apt-get install -y curl apt-utils git zip unzip zlib1g-dev libzip-dev vim \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install pdo_mysql bcmath \
    && curl https://deb.nodesource.com/setup_12.x | bash -

# install npm
RUN apt-get install -y nodejs \
    && node -v \
    && npm -v

# M1 mac の場合は node-sass のバイナリがないため、ビルドするためにpythonをインストール
RUN apt-get install -y python
