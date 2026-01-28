FROM mautic/mautic:latest

# Install GD dependencies
RUN apt-get update && apt-get install -y \
    libxpm4 libxpm-dev libjpeg62-turbo-dev libpng-dev \
    libfreetype6-dev libwebp-dev zlib1g-dev libavif-dev \
    # AMQP dependencies
    librabbitmq-dev \
  && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp --with-xpm \
  && docker-php-ext-install -j"$(nproc)" gd \
  # Install AMQP PHP extension
  && pecl install amqp \
  && docker-php-ext-enable amqp \
  # Install symfony/amqp-messenger
  && cd /var/www/html && composer require symfony/amqp-messenger \
  && apt-get clean && rm -rf /var/lib/apt/lists/*
