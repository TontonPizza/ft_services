FROM alpine

RUN apk upgrade
RUN apk add openssl vsftpd
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj "/C=FR/ST=Paris/L=Paris/O=42 School/OU=vo-nguye/CN=ft_services" -keyout /etc/ssl/private/vsftpd.key -out /etc/ssl/certs/vsftpd.crt

RUN mkdir -p /var/ftp

COPY srcs/vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY srcs/setup.sh /tmp/
COPY srcs/telegraf.conf /etc/telegraf.conf
COPY srcs/install.sh .

RUN chmod +x /tmp/setup.sh
RUN chmod +x /install.sh

RUN sh ./install.sh

EXPOSE 20 21


ENTRYPOINT /etc/init.d/telegraf start ; ./tmp/setup.sh
