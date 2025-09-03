# docker-roundcube-rootless
Yet another lightweight and rootless Roundcube image based on Alpine linux, lighttpd and msmtp.

# Compose file
```
services:
  roundcube:
    container_name: roundcube
    build:
      context: src
      args:
        - UID=34093
        - GID=34093
    restart: always
    user: 34093:34093
    environment:
      - IMAP_HOST=ssl://imaps.example.com:143
      - USE_SMTPD=false
      - SMTP_HOST=ssl://smtp.example.com:587
      - SMTP_AUTH_TYPE=PLAIN
      - SMTP_USER=user
      - SMTP_PASS=pass
      - PLUGINS=identity_switch
    volumes:
      - ./config:/config
      - ./data:/data
```

## Environment
Mandatory environment variables:
* ```IMAP_HOST``` - IMAP server to be used e.g. imap.example.com (or ssl://imaps.example.com:993 for SSL)

Optional environment variables:
* ```USE_SMTPD``` - Use msmtp as MTA
* ```SMTP_HOST``` - SMTP server e.g. smtp.example.com 
* ```SMTP_AUTH_TYPE``` - SMTP authentication type e.g. PLAIN
* ```SMTP_USER``` - SMTP username
* ```SMTP_PASS``` - SMTP password
* ```PLUGINS``` - Whitespace separated list of additional plugins to load.
	
## Mounts
Optional mounts:
* ```/config``` - For additional configuration like Roundcube plugins, extra configuration and msmtp configuration
* ```/data``` - For SQLite database for preserving settings

# Roundcube plugins
In order to load additional plugins use ```PLUGINS``` environment variable to list such plugins (plugin names separated by whitespace). To use 3rd party plugins add 
it to ```PLUGINS``` as usual and copy plugin files to ```config/plugins/plugin_name```.

# msmtp
Easiest way to get mail delivered from Roudncube is to directly use your ISPs or so SMTP server by setting ```SMTP_*``` environment variables. 
However for more complex needs (i.e. multiple identities each of which should use different SMTP server) local msmtp server can be enabled by
setting ```USE_SMTPD``` to true and omit ```SMTP_*``` environment variables. This causes msmtp to be launched on container start and Roundcube
to be pointed to it. Additionally msmtp must be configured by putting configuration to ```config/msmtp/msmtprc```.
