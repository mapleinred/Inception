#!/bin/bash
#echo "Environment Variables:"
#env

if [ ! -d "/var/www/wordpress/wp-admin" ]; then
    curl -o /tmp/wordpress.zip https://wordpress.org/latest.zip && \
    unzip /tmp/wordpress.zip -d /var/www && \
    rm /tmp/wordpress.zip
else
	echo "word press exist"
fi

echo " wait for mariadb"
# Wait for MariaDB to be available
#until nc -z mariadb 3306; do
#	echo "retry"
#    sleep 1
#done

echo " mariadb ready"

# Generate wp-config.php
#define('DB_NAME', getenv('MYSQL_DATABASE'));
#define('DB_USER', getenv('MYSQL_USER'));
#define('DB_PASSWORD', getenv('MYSQL_PASSWORD'));

echo "Generating wp-config.php..."
#cat > /var/www/wordpress/wp-config.php <<EOF
#<?php
#define('DB_NAME', '${MYSQL_DATABASE}')
#define('DB_USER', '${MYSQL_USER}')
#define('DB_PASSWORD', '${MYSQL_PASSWORD}')
#define('DB_HOST', 'mariadb');
#define('DB_CHARSET', 'utf8');
#define('DB_COLLATE', '');
#
#define( 'AUTH_KEY',         'put your unique phrase here' );
#define( 'SECURE_AUTH_KEY',  'put your unique phrase here' );
#define( 'LOGGED_IN_KEY',    'put your unique phrase here' );
#define( 'NONCE_KEY',        'put your unique phrase here' );
#define( 'AUTH_SALT',        'put your unique phrase here' );
#define( 'SECURE_AUTH_SALT', 'put your unique phrase here' );
#define( 'LOGGED_IN_SALT',   'put your unique phrase here' );
#define( 'NONCE_SALT',       'put your unique phrase here' );
#
#\$table_prefix = 'wp_';
#define('WP_DEBUG', false);
#if ( !defined('ABSPATH') ) {
#	define('ABSPATH', __DIR__ . '/');
#}
#
#require_once ABSPATH . 'wp-settings.php';
#EOF

cp wp-config-sample.php wp-config.php

sed -i "s@database_name_here@${MYSQL_DATABASE}@" wp-config.php
sed -i "s@username_here@${MYSQL_USER}@" wp-config.php
sed -i "s@password_here@${MYSQL_PASSWORD}@" wp-config.php
sed -i 's/localhost/mariadb/g' wp-config.php

# Set proper permissions

echo "Setting permissions..."
chown -R www-data:www-data /var/www/wordpress

# Start PHP-FPM

while ! mysqladmin ping -h mariadb -u${MYSQL_USER} -p${MYSQL_PASSWORD}
do
	echo "ping failed..."
	sleep 1
done
wp core install --allow-root --path=/var/www/wordpress --url=xzhang.42.fr --title="wp" --admin_user=${MYSQL_USER} --admin_password=${MYSQL_PASSWORD} --admin_email=fake@gmail.com

# Path to the flag file
FLAG_FILE="/var/www/wordpress/.search-replace-done"

# Check if the flag file exists
if [ ! -f "$FLAG_FILE" ]; then
    echo "Running search and replace for http to https..."
    
    # Run the search and replace command
    wp search-replace http https --report-changed-only --allow-root
    
    # Create the flag file to mark that the command has been run
    touch "$FLAG_FILE"
else
    echo "Search and replace has already been run. Skipping..."
fi

wp user create ${WP_USER} ${WP_EMAIL}  --allow-root --user_pass=${WP_PASSWORD}


echo "Starting PHP-FPM..."
exec php-fpm -F

