FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive

## Install php nginx supervisor
RUN apt update && \
    apt install -yf php-fpm php-cli php-gd php-mcrypt php-mysql php-curl nginx curl php-mbstring php-xml git unzip supervisor

# Composer
RUN \
  curl -sS https://getcomposer.org/installer | php && \
  mv composer.phar /usr/local/bin/composer && \
  composer config -g github-oauth.github.com bab3a00f53376efd336d3e92bc1b5d92ff7acaaa && \
  php -v


## Configuration
RUN sed -i 's/^listen\s*=.*$/listen = 127.0.0.1:9000/' /etc/php/7.0/fpm/pool.d/www.conf && \
    sed -i 's/^\;error_log\s*=\s*syslog\s*$/error_log = \/var\/log\/php\/cgi.log/' /etc/php/7.0/fpm/php.ini && \
    sed -i 's/^\;error_log\s*=\s*syslog\s*$/error_log = \/var\/log\/php\/cli.log/' /etc/php/7.0/cli/php.ini

COPY files/root /

#WORKDIR /var/www/
#VOLUME /var/www/

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
