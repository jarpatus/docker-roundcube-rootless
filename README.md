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
      - IMAP_HOST=ssl://imaps.example.com
      - PLUGINS=multiaccount_switcher
    volumes:
      - ./data:/data
      - ./config:/config
```

## Environment
Mandatory environment variables:
* ```IMAP_HOST``` - IMAP server e.g. imap.example.com or ssl://imaps.example.com for SSL ,

Optional environment variables:
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
