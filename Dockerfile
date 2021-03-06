ARG PHP_VERSION=7.4

FROM php:${PHP_VERSION}

ENV BUILD_PACKAGES="libfreetype6-dev libjpeg62-turbo-dev libpng-dev libxslt-dev libicu-dev libnotify-dev"

RUN set -eux; \

    # System Dependencies
    curl -sL https://deb.nodesource.com/setup_10.x | bash -; \
    curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -; \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list; \
    mkdir -p /usr/share/man/man1; \
    apt-get update; \
    apt-get install -y \
        ${BUILD_PACKAGES} \
        libmagickwand-dev \
        libmagickcore-dev \
        libmagickwand-6.q16-6 \
        libzip-dev \
        libmcrypt-dev \
        git \
        default-mysql-client \
        wget \
        unzip \
        zip \
        gnupg \
        procps \
        xvfb \
        libgtk2.0-0 \
        libgconf-2-4 \
        libnss3 \
        libxss1 \
        libasound2 \
        nodejs \
        yarn \
        default-jdk \
        chromium \
        rsync; \
    curl -O https://download.libsodium.org/libsodium/releases/libsodium-1.0.18.tar.gz; \
    tar xfvz libsodium-1.0.18.tar.gz; \
    cd libsodium-1.0.18; \
    ./configure; \
    make && make install; \
    cd ..; \
    rm -rf libsodium-1.0.18; \

    # PHP Extensions
    docker-php-ext-install -j$(nproc) \
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
        sockets; \
    docker-php-ext-configure gd --with-freetype --with-jpeg; \
    docker-php-ext-install -j$(nproc) gd; \
    pecl install imagick; \
    pecl install -f libsodium; \
    docker-php-ext-enable imagick; \

    # PHP Configuration
    echo "date.timezone=Europe/Rome" >> /usr/local/etc/php/conf.d/dev.ini; \
    echo "memory_limit=-1" >> /usr/local/etc/php/conf.d/dev.ini; \

    # Composer
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer; \

    # Cleanup
    pecl clear-cache; \
    apt-get remove --purge -y $BUILD_PACKAGES; \
    apt-get autoremove -y; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*
