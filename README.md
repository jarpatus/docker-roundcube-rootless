# docker-roundcube-rootless
Yet another rootless Roundcube based on Alpine linux and lighttpd and SQLite.

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
      - SMTP_HOST=ssl://smtp.example.com:587
      - SMTP_AUTH_TYPE=PLAIN
      - SMTP_USER=user
      - SMTP_PASS=pass
      - PLUGINS=multiaccount_switcher
    volumes:
      - ./config:/config
      - ./data:/data
```

## Environment
Mandatory environment variables:
* ```IMAP_HOST``` - IMAP server e.g. imap.example.com or ssl://imaps.example.com for SSL
* ```SMTP_HOST``` - SMTP server e.g. smtp.example.com

Optional environment variables:
* ```SMTP_AUTH_TYPE``` - SMTP authentication type e.g. PLAIN
* ```SMTP_USER``` - SMTP username
* ```SMTP_PASS``` - SMTP password
* ```PLUGINS``` - Whitespace separated list of additional plugins to load.
	
## Mounts
Optional mounts:
* ```/config``` - Additional configuration like plugins to be loaded on container start 
* ```/data``` - SQLite database location for preserving settings.

# Plugins
In order to load additional plugins use ```PLUGINS``` environment variable to list such plugins. In order to use external plugins add 
it to ```PLUGINS``` and store ```plugins/plugin_name``` under ```/config``` using mount so it should look like this:


```
/config
/config/plugins
/config/plugins/multiaccount_switcher
/config/plugins/multiaccount_switcher/...
```
