FROM mautic/mautic:latest

# Install GD dependencies and symfony/amqp-messenger
RUN apt-get update && apt-get install -y \
    libxpm4 libxpm-dev libjpeg62-turbo-dev libpng-dev \
    libfreetype6-dev libwebp-dev zlib1g-dev libavif-dev \
  && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp --with-xpm \
  && docker-php-ext-install -j"$(nproc)" gd \
  && cd /var/www/html && composer require symfony/amqp-messenger --no-interaction \
  && apt-get clean && rm -rf /var/lib/apt/lists/*
