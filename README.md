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
    volumes:
      - ./data:/data
```

## Environment
Mandatory environment variables:
* ```IMAP_HOST``` - IMAP server e.g. imap.example.com or ssl://imaps.example.com for SSL 

## Mounts
Optional mounts:
* ```/data``` - SQLite database for preserving settings.
