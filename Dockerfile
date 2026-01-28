FROM mautic/mautic:latest

# Install GD dependencies
RUN apt-get update && apt-get install -y \
    libxpm4 libxpm-dev libjpeg62-turbo-dev libpng-dev \
    libfreetype6-dev libwebp-dev zlib1g-dev libavif-dev \
  && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp --with-xpm \
  && docker-php-ext-install -j"$(nproc)" gd \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create entrypoint script to install amqp-messenger at runtime
RUN echo '#!/bin/bash\n\
if ! composer show symfony/amqp-messenger > /dev/null 2>&1; then\n\
  cd /var/www/html && composer require symfony/amqp-messenger --no-interaction\n\
fi\n\
exec "$@"' > /entrypoint-amqp.sh && chmod +x /entrypoint-amqp.sh

ENTRYPOINT ["/entrypoint-amqp.sh"]
CMD ["apache2-foreground"]
