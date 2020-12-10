FROM alpine:3.6

RUN apk update
RUN apk upgrade
RUN apk add openssl
RUN apk add supervisor curl

COPY ./srcs/telegraf.tar.gz  telegraf.tar.gz
RUN  tar xvf telegraf.tar.gz && \
     mv 'telegraf-1.16.0' telegraf
COPY srcs/telegraf.conf /etc/telegraf/telegraf.conf


RUN apk add --update nginx && rm -rf /var/cache/apk/*
RUN mkdir -p /tmp/nginx/client-body
RUN mkdir -p /run/nginx

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj '/C=FR/ST=75/L=Paris/O=42/CN=vo-nguye' -keyout /etc/ssl/certs/localhost.key -out /etc/ssl/certs/localhost.crt

COPY ./srcs/nginx_conf/nginx.conf /etc/nginx/nginx.conf
COPY ./srcs/nginx_conf/default.conf /etc/nginx/conf.d/default.conf
COPY ./srcs/sites /sites

ADD ./srcs/supervisor.conf /etc/supervisor.conf

EXPOSE 80 443

CMD ["supervisord", "-c", "/etc/supervisor.conf"]
