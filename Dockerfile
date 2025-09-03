# Start from Apline linux
FROM alpine:3.18

# Build args
ARG RC_VER=1.6.11
ARG UID=34093
ARG GID=34093

# Add user
RUN addgroup -g $GID roundcube
RUN adduser -s /sbin/nologin -G roundcube -D -u $UID roundcube

# Install development related packages not needed in production use
RUN apk add --no-cache bash nano inetutils-telnet

# Install supervisor
RUN apk add --no-cache supervisor 
RUN mkdir -p /run/supervisor
RUN chown roundcube:roundcube /run/supervisor

# Install php
RUN apk add --no-cache openssl php-ctype php-curl php-dom php-exif php-fileinfo php-fpm php-gd php-iconv php-intl php-json php-mbstring php-openssl php-pdo_sqlite php-session php-xml php-xmlwriter php-zip
RUN (cd /etc && ln -s php* php)
RUN (cd /usr/sbin && ln -s php-fpm* php-fpm)
RUN (cd /var/log && ln -s php* php)
RUN mkdir -p /run/php
RUN chown roundcube:roundcube /run/php /var/log/php*
	
# Install lighttpd
RUN apk add --no-cache lighttpd
RUN mkdir -p /run/lighttpd 
RUN chown roundcube:roundcube /run/lighttpd /var/log/lighttpd

# Install msmtp
RUN apk add --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community msmtp

# Install roundcube
RUN mkdir -p /opt/roundcube
RUN chown roundcube:roundcube /opt/roundcube 
ADD --chown=roundcube:roundcube https://github.com/roundcube/roundcubemail/releases/download/$RC_VER/roundcubemail-$RC_VER-complete.tar.gz /tmp/roundcube-complete.tar.gz
RUN tar -xzf /tmp/roundcube-complete.tar.gz --strip-components=1 -C /opt/roundcube
RUN chown -R roundcube:roundcube /opt/roundcube
RUN rm /tmp/roundcube-complete.tar.gz
RUN rm -rf /opt/roundcube/installer

# Copy application files to the image
RUN mkdir -p /config /data
COPY ./app /app
RUN tar c -C /app etc | tar x -v -C /

# Drop root
USER roundcube

# Run init script
CMD /app/init.sh
