FROM debian:11

# Install dependencies
RUN apt-get update && \
    apt-get install -y php php-fpm php-json php-mysqli php-mysql php-curl curl unzip netcat default-mysql-client && \
    apt-get clean

RUN mkdir -p /etc/php/7.4/fpm/pool.d
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
RUN ln -s /usr/sbin/php-fpm7.4 /usr/sbin/php-fpm

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

VOLUME /var/www/wordpress
# Download WordPress
#RUN curl -o /tmp/wordpress.zip https://wordpress.org/latest.zip && \
#    unzip /tmp/wordpress.zip -d /var/www && \
#    rm /tmp/wordpress.zip

# Set correct ownership
#RUN chown -R www-data:www-data /var/www/wordpress

# Copy setup script and configuration
COPY tools/setup.sh /tmp/setup.sh
RUN chmod +x /tmp/setup.sh

# Expose PHP-FPM port
EXPOSE 9000
WORKDIR /var/www/wordpress
# Run setup and start PHP-FPM
ENTRYPOINT ["/tmp/setup.sh"]
RUN mkdir -p /run/php && chown -R www-data:www-data /run/php
CMD ["php-fpm7.4", "-F"]

