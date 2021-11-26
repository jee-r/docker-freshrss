# docker-freshrss
In the mean time i write a real readme here is an example of docker-compose 

## docker-compose.yml

```
version: "3.9"

services:
  php:
    # build: .
    image: ghcr.io/jee-r/freshrss:dev
    restart: unless-stopped
    user: 1000:1000
    environment:
      - HOME=/app
      - TZ=Europe/Paris
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - ./app:/app
    healthcheck:
      test: ["CMD", "php /app/freshrss/app/actualize_script.php"]
      interval: 20m
      timeout: 2m
      #retries: 3
      start_period: 1m

  nginx:
    image: nginxinc/nginx-unprivileged:alpine
    user: "${UID:-1000}:${GID:-1000}"
    restart: unless-stopped
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - ./nginx_default.conf:/etc/nginx/conf.d/default.conf
      - ./app:/app
    ports:
      - "0.0.0.0:8800:8080"

  db:
    image: mariadb:latest
    container_name: db
    restart: unless-stopped
    volumes:
      - db:/var/lib/mysql/data
    environment:
      - MYSQL_RANDOM_ROOT_PASSWORD=yes
      - MYSQL_DATABASE=freshrss
      - MYSQL_USER=freshrss
      - MYSQL_PASSWORD=<CHANGE ME>  # You should really change it

volumes:
  app:
  db:

#networks:
#  freshrss:
#    external: true
```



## nginx_default.conf

```
server {
    listen 			8080;
	listen      	[::]:8080;
	server_name 	_;


    access_log 			/tmp/nginx_access.log;
	error_log 			/tmp/nginx_error.log;
	error_log 			/proc/self/fd/2;

	root 			        /app/freshrss/p;
    client_max_body_size    64M;

    index index.php index.html;

    location ~ \.php$ {
        try_files $uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass php:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param PATH_INFO $fastcgi_path_info;
    }

    location / {
        try_files $uri $uri/ /index.php?$query_string;
        gzip_static on;
    }

```
