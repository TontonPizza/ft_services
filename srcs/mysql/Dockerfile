FROM alpine:3.12

USER root

RUN apk update
RUN apk add mariadb mariadb-client && apk add --no-cache --upgrade bash \
    && rm -rf /var/cache/apk/*

RUN apk add supervisor curl

COPY ./srcs/telegraf.tar.gz  telegraf.tar.gz
RUN  tar xvf telegraf.tar.gz && \
     mv 'telegraf-1.16.0' telegraf
COPY srcs/telegraf.conf /etc/telegraf/telegraf.conf
ADD ./srcs/supervisor.conf /etc/supervisor.conf

COPY ./srcs/init_docker.sh .
COPY ./srcs/init_mysql.sh .
COPY ./srcs/wordpress.sql .

RUN chmod 777 init_docker.sh
RUN chmod 777 init_mysql.sh

EXPOSE 3306
VOLUME /var/lib/mysql

COPY ./srcs/my.cnf /etc/mysql/my.cnf
COPY ./srcs/my.cnf /etc/.

CMD ["supervisord", "-c", "/etc/supervisor.conf"]
