# [Choice] PHP version (use -bullseye variants on local arm64/Apple Silicon): 8, 8.1, 8.0, 7, 7.4, 7.3, 8-bullseye, 8.1-bullseye, 8.0-bullseye, 7-bullseye, 7.4-bullseye, 7.3-bullseye, 8-buster, 8.1-buster, 8.0-buster, 7-buster, 7.4-buster
ARG VARIANT=8-bullseye
FROM mcr.microsoft.com/vscode/devcontainers/php:0-${VARIANT}

# Install MariaDB client
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y mariadb-client \ 
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Install php-mysql driver
RUN docker-php-ext-install mysqli pdo pdo_mysql

# [Choice] Node.js version: none, lts/*, 16, 14, 12, 10
ARG NODE_VERSION="none"
RUN if [ "${NODE_VERSION}" != "none" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

# [Optional] Uncomment this section to install additional OS packages.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends cron libzip-dev zip libpng-dev libicu-dev libxml2-dev libyaml-dev libxslt-dev libwebp-dev libfreetype6-dev libjpeg62-turbo-dev

# [Optional] Uncomment this line to install global node packages.
# RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g <your-package-here>" 2>&1

# Install zip
RUN docker-php-ext-install zip

# Install intl
RUN docker-php-ext-install intl

# Install gd
RUN docker-php-ext-configure gd --with-jpeg --with-webp --with-freetype
RUN docker-php-ext-install gd

# Install soap
RUN docker-php-ext-install soap

# Install opcache
RUN docker-php-ext-install opcache

# Install exif
RUN docker-php-ext-install exif

# Set PHP variables for moodle
RUN echo 'max_execution_time = 300' >> /usr/local/etc/php/conf.d/docker-php-maxexectime.ini;
RUN echo 'upload_max_filesize = 2048M' >> /usr/local/etc/php/conf.d/docker-php-uploadmaxfilesize.ini;
RUN echo 'post_max_size = 2048M' >> /usr/local/etc/php/conf.d/docker-php-postmaxsize.ini;
RUN echo 'max_input_vars = 5000' >> /usr/local/etc/php/conf.d/docker-php-maxinputvars.ini;
RUN echo 'date.timezone = Europe/Amsterdam' >> /usr/local/etc/php/conf.d/docker-php-datetimezone.ini;
