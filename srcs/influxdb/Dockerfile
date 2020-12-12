FROM alpine:latest
EXPOSE 8086

VOLUME /var/lib/influxdb/data

RUN apk update
RUN apk add influxdb 
RUN apk add supervisor curl

COPY ./srcs/telegraf.tar.gz  telegraf.tar.gz
RUN  tar xvf telegraf.tar.gz && \
     mv 'telegraf-1.16.0' telegraf
COPY srcs/telegraf.conf /etc/telegraf/telegraf.conf
ADD ./srcs/supervisor.conf /etc/supervisor.conf

COPY ./srcs/influxd_start.sh /etc/influxd_start.sh
CMD ["supervisord", "-c", "/etc/supervisor.conf"]
