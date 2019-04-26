FROM php:7.2

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get update \
    && apt-get install -y \
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
        zip \
        gnupg \
        procps \
        xvfb \
        libgtk2.0-0 \
        libnotify-dev \
        libgconf-2-4 \
        libnss3 \
        libxss1 \
        libasound2 \
        nodejs \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install -j$(nproc) \
        iconv \
        xsl \
        intl \
        zip \
        pdo_mysql \
        opcache \
        pcntl \
        soap \
        bcmath \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && pecl install imagick \
    && docker-php-ext-enable imagick

RUN echo "date.timezone=Europe/Rome" >> /usr/local/etc/php/conf.d/dev.ini \
    && echo "memory_limit=-1" >> /usr/local/etc/php/conf.d/dev.ini

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
