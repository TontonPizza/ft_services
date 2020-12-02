ARG VERSION=3.6

FROM alpine:${VERSION}

RUN apk update
RUN apk upgrade
RUN apk add vsftpd

COPY ./srcs/vsftpd.conf /etc/vsftpd/vsftpd.conf


EXPOSE 21
VOLUME /var/lib/ftp
ADD ./srcs/ft_services.txt /var/lib/ftp/ft_services.txt

CMD vsftpd /etc/vsftpd/vsftpd.conf && sh
