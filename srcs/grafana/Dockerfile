FROM alpine:latest

EXPOSE 3000

RUN apk add --update --no-cache bash \
	--repository=http://dl-cdn.alpinelinux.org/alpine/edge/main libc6-compat

COPY srcs/grafana-7.0.3.linux-amd64.tar.gz ./
RUN tar xf grafana-7.0.3.linux-amd64.tar.gz && rm grafana-7.0.3.linux-amd64.tar.gz
#COPY ./srcs/grafana.db ./grafana-7.0.3/data/
COPY ./srcs/start.sh .

#COPY wrapper.sh .
#COPY grafana_init.sh
#COPY liveness.sh .
#
#RUN mkdir -m 755 /etc/telegraf
#COPY telegraf.conf /etc/telegraf/.
#COPY telegraf-1.6.3-static_linux_amd64.tar.gz .
#RUN tar xf telegraf-1.6.3-static_linux_amd64.tar.gz && \
#	rm telegraf-1.6.3-static_linux_amd64.tar.gz

CMD sh start.sh ; sleep infinity & wait
