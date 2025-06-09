FROM debian:11

# Install MariaDB
RUN apt-get update && apt-get install -y mariadb-server



# Create directory for custom initialization
#RUN mkdir -p /docker-entrypoint-initdb.d

# Ensure MySQL run directory exists and has correct permissions
#RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld
RUN mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql


# Copy setup script
COPY tools/setup.sh /docker-entrypoint-initdb.d/setup.sh
RUN chmod +x /docker-entrypoint-initdb.d/setup.sh

RUN echo "\n[mysqld]\nskip-networking=0\nskip-bind-address" >> /etc/mysql/mariadb.cnf
# Expose MySQL Port
EXPOSE 3306

# Start MariaDB properly
ENTRYPOINT ["bash", "-c", "/docker-entrypoint-initdb.d/setup.sh"]
CMD ["mysqld"]

