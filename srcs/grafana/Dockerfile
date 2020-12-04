FROM alpine:latest

EXPOSE 3000

RUN apk add --update --no-cache bash \
	--repository=http://dl-cdn.alpinelinux.org/alpine/edge/main libc6-compat
RUN apk add curl supervisor

COPY srcs/grafana-7.0.3.linux-amd64.tar.gz ./
RUN tar xf grafana-7.0.3.linux-amd64.tar.gz && rm grafana-7.0.3.linux-amd64.tar.gz
#COPY ./srcs/grafana.db ./grafana-7.0.3/data/
COPY ./srcs/start.sh .
COPY ./srcs/grafana.db /grafana-7.0.3/data/grafana.db
#COPY wrapper.sh .
#COPY grafana_init.sh
#COPY liveness.sh .
#
#RUN mkdir -m 755 /etc/telegraf
#COPY telegraf.conf /etc/telegraf/.
#COPY telegraf-1.6.3-static_linux_amd64.tar.gz .
#RUN tar xf telegraf-1.6.3-static_linux_amd64.tar.gz && \
#	rm telegraf-1.6.3-static_linux_amd64.tar.gz

RUN curl 'https://dl.influxdata.com/telegraf/releases/telegraf-1.16.0_linux_i386.tar.gz' > telegraf.tar.gz && \
    tar xvf telegraf.tar.gz && \
    mv 'telegraf-1.16.0' telegraf
COPY srcs/telegraf.conf /etc/telegraf/telegraf.conf
ADD ./srcs/supervisor.conf /etc/supervisor.conf

CMD sh start.sh ; sleep infinity & wait

#CMD ["supervisord", "-c", "/etc/supervisor.conf"]