FROM j33r/php-fpm:latest

LABEL maintainer="Jee"

ARG UID=1001
ARG GID=1001
ARG GROUP_NAME=freshrss
ARG USER_NAME=freshrss
ARG SUPERCRONIC_VERSION=0.1.9
ARG SUPERCRONIC_ARCH=amd64
ARG SUPERCRONIC_SHA1SUM=5ddf8ea26b56d4a7ff6faecdd8966610d5cb9d85
ARG SUPERCRONIC=supercronic-linux-${SUPERCRONIC_ARCH}

ENV CRON=false

COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

USER root
RUN apk update && \
    apk upgrade && \
    echo "Create freshrss user ..." && \
    if [ "$(grep ':'${GID}':' /etc/group)" == "" ]; then \
      addgroup -g ${GID} ${GROUP_NAME}; \
    else \
      GROUP_NAME=$(grep ':'${GID}':' /etc/group | cut -d: -f1); \
    fi && \
    if [ "$(grep ${UID} /etc/passwd)" == "" ]; then \
      adduser -h /app -s /bin/sh -G ${GROUP_NAME} -D -u ${UID} ${USER_NAME}; \
    fi && \
    curl -o /tmp/${SUPERCRONIC} -L https://github.com/aptible/supercronic/releases/download/v${SUPERCRONIC_VERSION}/supercronic-linux-${SUPERCRONIC_ARCH} && \
    ls -lsha /tmp/${SUPERCRONIC} && \
    echo "${SUPERCRONIC_SHA1SUM}  /tmp/${SUPERCRONIC}" | sha1sum -c - && \
    chmod +x /tmp/${SUPERCRONIC} && \
    mv /tmp/${SUPERCRONIC} /usr/local/bin/supercronic && \
    mkdir -p /php && \
    mkdir -p /app/cron && \
    git clone https://github.com/FreshRSS/FreshRSS.git /app/FreshRss && \
    echo '*/10 * * * * /usr/sbin/php7 /app/FreshRss/app/actualize_script.php' >> /app/cron_freshrss_feed && \
    chown -R ${UID}:${GID} /php /app && \
    chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /app
USER $USER_NAME:$GROUP_NAME

COPY ./php-fpm.conf /etc/php7/php-fpm.conf

STOPSIGNAL SIGQUIT
VOLUME ["/php", "/app"]
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
