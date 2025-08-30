# Start from Apline linux
FROM alpine:3.18

# Build args
ARG UID=34093
ARG GID=34093

# Add packages
RUN apk add --no-cache supervisor
RUN apk add --no-cache openssl 
RUN apk add --no-cache php-ctype php-curl php-dom php-exif php-fileinfo php-fpm php-gd php-iconv php-intl php-json php-mbstring php-openssl php-pdo_sqlite php-session php-xml php-xmlwriter php-zip
RUN apk add --no-cache lighttpd 

# Add development related packages not needed in prod
RUN apk add --no-cache bash nano inetutils-telnet

# Add user
RUN addgroup -g $GID roundcube
RUN adduser -s /sbin/nologin -G roundcube -D -u $UID roundcube

# Create config files
RUN (cd /etc && ln -s php* php)
RUN (cd /usr/sbin && ln -s php-fpm* php-fpm)
RUN mkdir -p /run/supervisor /run/php /run/lighttpd /opt/roundcube /data
RUN chown roundcube:roundcube /run/supervisor /run/php /run/lighttpd /opt/roundcube /data
COPY ./app /app
RUN tar c -C /app etc | tar x -v -C /

# Drop root
USER roundcube

# Install roundcube
ADD --chown=roundcube:roundcube https://github.com/roundcube/roundcubemail/releases/download/1.6.11/roundcubemail-1.6.11-complete.tar.gz /tmp/roundcube-complete.tar.gz
RUN tar -xzf /tmp/roundcube-complete.tar.gz --strip-components=1 -C /opt/roundcube
RUN rm /tmp/roundcube-complete.tar.gz
RUN rm -rf /opt/roundcube/installer

# Run init script
CMD /app/init.sh
