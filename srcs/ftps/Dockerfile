FROM alpine:3.6

EXPOSE 21 22


RUN apk update
RUN apk upgrade
RUN apk add vsftpd openssl curl supervisor

COPY ./srcs/vsftpd.conf /etc/vsftpd/vsftpd.conf

RUN mkdir -p /etc/ssl-vsftpd/private
RUN chmod 700 /etc/ssl-vsftpd/private
RUN openssl req -x509 -nodes -days 365 -newkey rsa:1024 -subj '/C=FR/ST=75/L=Paris/O=42/CN=vo-nguye' -keyout /etc/ssl-vsftpd/private/vsftpd.key -out /etc/ssl-vsftpd/private/vsftpd.pem

VOLUME /var/lib/ftp
RUN mkdir /home/ftp
RUN mkdir /home/toto
ADD ./srcs/ft_services.txt /var/lib/ftp/ft_services.txt
ADD ./srcs/ft_services.txt /home/toto/
RUN chmod 777 -R /var/lib/ftp
RUN chmod 777 -R /home/ftp

RUN adduser admin -D
RUN echo -e "admin\nadmin" | passwd admin
RUN chown admin /var/lib/ftp
RUN chown admin /home/ftp


COPY ./srcs/telegraf.tar.gz  telegraf.tar.gz
RUN  tar xvf telegraf.tar.gz && \
     mv 'telegraf-1.16.0' telegraf
COPY srcs/telegraf.conf /etc/telegraf/telegraf.conf
ADD ./srcs/supervisor.conf /etc/supervisor.conf

CMD ["supervisord", "-c", "/etc/supervisor.conf"]