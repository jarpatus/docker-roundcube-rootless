#!/bin/sh

# Set defaults
[ "$USE_SMTPD" != "true" ] && export USE_SMTPD=false

# Apply roundcube configuration from environment variables
cp -v /app/opt/roundcube/config/config.inc.php /opt/roundcube/config/config.inc.php
[ -n "$IMAP_HOST" ] && echo "\$config['imap_host'] = '$IMAP_HOST';" >> /opt/roundcube/config/config.inc.php
[ "$USE_SMTPD" == "true" ] && echo "\$config['smtp_host'] = 'localhost:2525';" >> /opt/roundcube/config/config.inc.php
[ -n "$SMTP_HOST" ] && echo "\$config['smtp_host'] = '$SMTP_HOST';" >> /opt/roundcube/config/config.inc.php
[ -n "$SMTP_AUTH_TYPE" ] && echo "\$config['smtp_auth_type'] = '$SMTP_AUTH_TYPE';" >> /opt/roundcube/config/config.inc.php
[ -n "$SMTP_USER" ] && echo "\$config['smtp_user'] = '$SMTP_USER';" >> /opt/roundcube/config/config.inc.php
[ -n "$SMTP_PASS" ] && echo "\$config['smtp_pass'] = '$SMTP_PASS';" >> /opt/roundcube/config/config.inc.php
echo "\$config['plugins'] = [" >> /opt/roundcube/config/config.inc.php
echo "  'archive'," >> /opt/roundcube/config/config.inc.php
echo "  'zipdownload'," >> /opt/roundcube/config/config.inc.php
for plugin in $PLUGINS; do 
  echo "  '$plugin'," >> /opt/roundcube/config/config.inc.php
done
echo "];" >> /opt/roundcube/config/config.inc.php

# Apply additional roundcube configuration from /config
[ -d "/config/roundcube/plugins" ] && cp -Rv /config/roundcube/plugins /opt/roundcube
if [ -f "/config/roundcube/config.inc.php" ]; then
  cat /config/roundcube/config.inc.php >> /opt/roundcube/config/config.inc.php
fi

# Apply msmtp configuration from /config
if [ -f "/config/msmtp/msmtprc" ]; then
  cp -v /config/msmtp/msmtprc /home/roundcube/.msmtprc
  chmod go-rwx /home/roundcube/.msmtprc
fi

# Run supervisord
exec supervisord
