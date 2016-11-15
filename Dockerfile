FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive

## Install php nginx supervisor
RUN apt update && apt install -yf php-fpm php-cli php-gd php-mcrypt php-mysql php-curl php-redis nginx curl php-mbstring php-xml git unzip supervisor
RUN php -v
RUN nginx -v

# Composer
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

# prestissimo - composer parallel install plugin
RUN composer global require "hirak/prestissimo:^0.3"

## Configuration
RUN sed -i 's/^listen\s*=.*$/listen = 127.0.0.1:9000/' /etc/php/7.0/fpm/pool.d/www.conf && \
    sed -i 's/^\;error_log\s*=\s*syslog\s*$/error_log = \/var\/log\/php\/cgi.log/' /etc/php/7.0/fpm/php.ini && \
    sed -i 's/^\;error_log\s*=\s*syslog\s*$/error_log = \/var\/log\/php\/cli.log/' /etc/php/7.0/cli/php.ini

COPY files/root /

#WORKDIR /var/www/
#VOLUME /var/www/

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
