FROM debian:11

# Install dependencies (fix typo: opnessl → openssl)
RUN apt-get update && apt-get install -y nginx openssl

# Create SSL directory
RUN mkdir -p /etc/nginx/ssl

RUN openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 \
    -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=SG/ST=Singapore/L=Singapore/O=SUTD/OU=42/CN=xzhang.42.fr"

# Copy configuration files (fix paths and typos)
COPY conf/nginx.conf /etc/nginx/nginx.conf

RUN rm -f /etc/nginx/sites-enabled/default
RUN rm -f /etc/nginx/sites-available/default
#RUN rm /etc/nginx/conf.d/default.conf

# Expose HTTPS port
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
#CMD ["sleep", "infinity"]
