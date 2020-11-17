ARG VERSION=3.6

FROM alpine:${VERSION}

RUN apk update
RUN apk upgrade
RUN apk add openrc --no-cache
RUN apk add openssl
RUN apk add curl
RUN apk add nano
RUN apk add wget

RUN apk add vsftpd

COPY ./srcs/vsftpd.conf /etc/vsftpd/vsftpd.conf


EXPOSE 21


CMD vsftpd /etc/vsftpd/vsftpd.conf && sh
