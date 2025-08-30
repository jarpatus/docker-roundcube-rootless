#!/bin/sh

# Copy roundcube confs
cp -Rv /app/opt/* /opt
cp -Rv /config/plugins/* /opt/roundcube/plugins

# Apply configuration from environment variables
echo "\$config['imap_host'] = '$IMAP_HOST';" >> /opt/roundcube/config/config.inc.php

echo "\$config['plugins'] = [" >> /opt/roundcube/config/config.inc.php
echo "  'archive'," >> /opt/roundcube/config/config.inc.php
echo "  'zipdownload'," >> /opt/roundcube/config/config.inc.php
for plugin in $PLUGINS; do 
  echo "  '$plugin'," >> /opt/roundcube/config/config.inc.php
done
echo "];" >> /opt/roundcube/config/config.inc.php

# Run supervisord
exec supervisord
