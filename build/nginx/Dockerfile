FROM j33r/nginx:latest
LABEL maintainer="Jee"

ARG GID=1000
ARG GROUP_NAME=php

USER root

RUN apk update && \
    apk upgrade && \
    apk --no-cache add shadow && \
    if [ "$(grep ':'${GID}':' /etc/group)" == "" ]; then \
      addgroup -g ${GID} ${GROUP_NAME}; \
    else \
      GROUP_NAME=$(grep ':'${GID}':' /etc/group | cut -d: -f1); \
    fi && \
    usermod -a -G ${GID} nginx

USER 101
COPY ./freshrss.conf /etc/nginx/conf.d/default.conf
