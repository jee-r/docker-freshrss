#!/bin/sh

if [ ! -f /app/freshrss/config.default.php ]; then
  if [ -z ${FRESHRSS_RELEASE+x} ]; then 
    FRESHRSS_RELEASE=$(curl -sX GET "https://api.github.com/repos/FreshRSS/FreshRSS/releases/latest" \
    | awk '/tag_name/{print $4;exit}' FS='[""]');
  fi

  curl -o \
    /tmp/freshrss.tar.gz -L \
      "https://github.com/FreshRSS/FreshRSS/archive/${FRESHRSS_RELEASE}.tar.gz"
    mkdir /app/freshrss 
    tar xf \
      /tmp/freshrss.tar.gz -C \
      /app/freshrss --strip-components=1 
   sed -i "s|'disable_update' => false,|'disable_update' => true,|g" \
    /app/freshrss/config.default.php 
fi

chmod -R 775 /app

php-fpm

