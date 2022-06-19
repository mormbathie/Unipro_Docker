# Application Codé par Mor Mbathie Unipro@2022 L3GIA
#Email: mormbathie98@gmail.com
#Numéro Téléphone : +221 77 459 59 70
FROM php:8.1.6-fpm

# Arguments defined in docker-compose.yml
ARG user
ARG uid

RUN curl -fsSLO https://get.docker.com/builds/Linux/x86_64/docker-17.04.0-ce.tgz \
  && tar xzvf docker-17.04.0-ce.tgz \
  && mv docker/docker /usr/local/bin \
  && rm -r docker docker-17.04.0-ce.tgz

# Installation des dependences
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# Supprimer les  caches
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Installation des extensions  PHP
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Installation du composer dernier version
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# cration du system d'utlisateur
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

# Set working directory
WORKDIR /var/www

USER $user
