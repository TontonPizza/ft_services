ARG VERSION=3.6

FROM alpine:${VERSION}

RUN apk update
RUN apk upgrade
RUN apk add vsftpd curl supervisor

COPY ./srcs/vsftpd.conf /etc/vsftpd/vsftpd.conf


EXPOSE 21
VOLUME /var/lib/ftp
ADD ./srcs/ft_services.txt /var/lib/ftp/ft_services.txt

RUN curl 'https://dl.influxdata.com/telegraf/releases/telegraf-1.16.0_linux_i386.tar.gz' > telegraf.tar.gz && \
    tar xvf telegraf.tar.gz && \
    mv 'telegraf-1.16.0' telegraf
COPY srcs/telegraf.conf /etc/telegraf/telegraf.conf
ADD ./srcs/supervisor.conf /etc/supervisor.conf

CMD ["supervisord", "-c", "/etc/supervisor.conf"]