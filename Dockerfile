FROM php:8-fpm-alpine3.14

LABEL name="docker-freshrss" \
      maintainer="Jee jee@jeer.fr" \
      description="FreshRSS is an RSS aggregator and reader. It allows you to read and follow several news websites at a glance without the need to browse from one website to another." \
      url="https://freshrss.org" \
      org.label-schema.vcs-url="https://github.com/jee-r/docker-freshrss" \
      org.opencontainers.image.source="https://github.com/jee-r/docker-freshrss"


ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions && \
    sync && \
    apk add --virtual=base --upgrade --no-cache \
      curl \
      bash \
      tzdata && \
    /usr/local/bin/install-php-extensions \
      gmp \
      intl \
      zip \
      opcache \
      mysqli \
      pdo_pgsql \
      pdo_mysql && \
    mkdir -p /php && \
    mkdir -p /app && \
    chmod -R 777 /app /php



#RUN apk update && \
#    git clone https://github.com/FreshRSS/FreshRSS.git /app/FreshRss && \
#    echo '*/10 * * * * /usr/sbin/php7 /app/FreshRss/app/actualize_script.php' >> /app/cron_freshrss_feed && \
#    chown -R ${UID}:${GID} /php /app && \
#    chmod +x /usr/local/bin/entrypoint.sh

COPY rootfs /

WORKDIR /app

STOPSIGNAL SIGQUIT
VOLUME ["/php", "/app"]
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
