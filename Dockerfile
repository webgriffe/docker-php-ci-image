FROM php:7.1

RUN apt-get update && apt-get install -y \
							libfreetype6-dev \
							libjpeg62-turbo-dev \
							libmcrypt-dev \
							libpng-dev \
							libxslt-dev \
							libicu-dev \
							git \
							mysql-client \
							libmagickwand-dev \
							libmagickcore-dev \
							wget \
							unzip \
                                                        zip

RUN docker-php-ext-install -j$(nproc) iconv mcrypt xsl intl zip pdo_mysql opcache pcntl soap
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install -j$(nproc) gd
RUN pecl install imagick
RUN docker-php-ext-enable imagick

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs

RUN echo "date.timezone=Europe/Rome" >> /usr/local/etc/php/conf.d/dev.ini
RUN echo "memory_limit=-1" >> /usr/local/etc/php/conf.d/dev.ini

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
