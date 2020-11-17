ARG VERSION=3.6

FROM alpine:${VERSION}

RUN apk update
RUN apk upgrade
RUN apk add openrc --no-cache
RUN apk add openssl
RUN apk add curl
RUN apk add nano
RUN apk add wget

RUN apk add --update nginx && rm -rf /var/cache/apk/*
RUN mkdir -p /tmp/nginx/client-body
RUN mkdir -p /run/nginx
RUN apk update

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj '/C=FR/ST=75/L=Paris/O=42/CN=vo-nguye' -keyout /etc/ssl/certs/localhost.key -out /etc/ssl/certs/localhost.crt

COPY ./srcs/nginx_conf/nginx.conf /etc/nginx/nginx.conf
COPY ./srcs/nginx_conf/default.conf /etc/nginx/conf.d/default.conf
COPY ./srcs/sites /sites



EXPOSE 22 80 443

CMD ["nginx", "-g", "daemon off;"]
