FROM alpine:3.12
EXPOSE 5050

RUN apk update && apk upgrade
RUN apk --no-cache add nginx supervisor curl openrc
RUN apk add php7 php7-fpm php7-opcache php7-gd php7-mysqli php7-zlib php7-curl php7-mbstring php7-json php7-session

COPY ./srcs/wordpress.tar.gz  wordpress.tar.gz
RUN mkdir www
RUN tar -xf wordpress.tar.gz
RUN mv wordpress/* /www
RUN rm -rf /var/cache/apk/*


COPY ./srcs/wp-config.php /www/wp-config.php
COPY srcs/nginx.conf /etc/nginx/nginx.conf

#COPY srcs/www.conf /etc/php7/php-fpm.d/www.conf
COPY srcs/supervisor.conf /etc/supervisor/conf.d/supervisord.conf

RUN mkdir /run/nginx

COPY ./srcs/telegraf.tar.gz  telegraf.tar.gz
RUN  tar xvf telegraf.tar.gz && \
     mv 'telegraf-1.16.0' telegraf
COPY srcs/telegraf.conf /etc/telegraf/telegraf.conf
ADD ./srcs/supervisor.conf /etc/supervisor.conf

CMD ["supervisord", "-c", "/etc/supervisor.conf"]
