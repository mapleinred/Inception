#!/bin/bash

# Ensure MySQL is running before executing commands
#service mysql start
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB database..."
    mysql_install_db --user=mysql --ldata=/var/lib/mysql
fi


echo "Starting temporary MariaDB instance..."
mysqld_safe --datadir=/var/lib/mysql --nowatch

echo "Waiting for MariaDB to be ready..."
until mysqladmin ping -h"localhost" --silent; do
	echo "Waiting for MariaDB to be ready..."
	sleep 5
done

# Create database and user

echo "Creating database and user..."

mysql -u root -p${MYSQL_ROOT_PASSWORD} <<EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER '${MYSQL_USER}'@'srcs-wordpress-1.srcs_inception' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'srcs-wordpress-1.srcs_inception';
FLUSH PRIVILEGES;
EOF

echo "Stopping temporary instance..."
mysqladmin -uroot -p${MYSQL_ROOT_PASSWORD} shutdown

echo "Starting final MariaDB instance..."
exec mysqld


echo "Database and user setup complete."
