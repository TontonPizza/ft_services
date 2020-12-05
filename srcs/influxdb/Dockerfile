FROM alpine:latest
EXPOSE 8086

VOLUME /root/.influxdb

RUN apk update
RUN apk add influxdb 
RUN apk add supervisor curl

RUN curl 'https://dl.influxdata.com/telegraf/releases/telegraf-1.16.0_linux_i386.tar.gz' > telegraf.tar.gz && \
    tar xvf telegraf.tar.gz && \
    mv 'telegraf-1.16.0' telegraf
COPY srcs/telegraf.conf /etc/telegraf/telegraf.conf
ADD ./srcs/supervisor.conf /etc/supervisor.conf

COPY ./srcs/influxd_start.sh /etc/influxd_start.sh
CMD ["supervisord", "-c", "/etc/supervisor.conf"]
