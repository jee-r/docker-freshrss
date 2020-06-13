#!/bin/sh
if $CRON; then
   /usr/local/bin/supercronic /app/cron_freshrss_feed
else
  /usr/sbin/php-fpm7 -y /etc/php7/php-fpm.conf
fi
