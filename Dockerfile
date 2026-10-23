FROM php:8.3-fpm-alpine

# Install system dependencies and PHP extensions
RUN apk add --no-cache nginx supervisor curl libpng-dev libxml2-dev zip unzip git openssl-dev postgresql-dev \
    && docker-php-ext-install pdo pdo_pgsql pdo_mysql bcmath gd

# Configure Nginx
COPY .docker/nginx.conf /etc/nginx/nginx.conf

# Set up working directory
WORKDIR /var/www/html
COPY . /var/www/html

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN composer install --no-dev --optimize-autoloader

# Set permissions
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Expose port and start system via supervisor
EXPOSE 80
CMD ["sh", "-c", "nginx && php-fpm"]
