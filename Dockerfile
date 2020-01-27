FROM php:7.2

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && mkdir -p /usr/share/man/man1 \
    && apt-get update \
    && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libxslt-dev \
        libicu-dev \
        git \
        default-mysql-client \
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
        yarn \
        default-jdk \
        chromium \
        rsync \
    && curl -O https://download.libsodium.org/libsodium/releases/libsodium-1.0.18.tar.gz \
    && tar xfvz libsodium-1.0.18.tar.gz \
    && cd libsodium-1.0.18 \
    && ./configure \
    && make && make install \
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
        exif \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && pecl install imagick \
    && pecl install -f libsodium \
    && docker-php-ext-enable imagick

RUN echo "date.timezone=Europe/Rome" >> /usr/local/etc/php/conf.d/dev.ini \
    && echo "memory_limit=-1" >> /usr/local/etc/php/conf.d/dev.ini

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
