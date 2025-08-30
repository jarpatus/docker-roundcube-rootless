#!/bin/sh

# Copy roundcube config files to /opt
cp -Rv /app/opt/* /opt

# Apply configuration from encironment variables
echo "\$config['imap_host'] = '$IMAP_HOST';" >> /opt/roundcube/config/config.inc.php

# Run supervisord
exec supervisord
