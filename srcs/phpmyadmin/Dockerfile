FROM alpine:3.12


RUN apk --no-cache add nginx supervisor curl

RUN apk add php7-fpm php-mbstring php7-openssl php7-json php7-dom php7-zip php7-mysqli \
			php7-curl php7-session php7-opcache php7-gd php7-zlib  php7-common \
			php7-iconv php7-xml php7-imap php7-cgi fcgi \
			php7-pdo php7-pdo_mysql php7-soap php7-xmlrpc php7-posix php7-mcrypt php7-gettext php7-ldap php7-ctype php7-dom

RUN  rm /etc/nginx/conf.d/default.conf
COPY srcs/nginx.conf /etc/nginx/nginx.conf
COPY srcs/www.conf /etc/php7/php-fpm.d/www.conf
COPY srcs/supervisor.conf /etc/supervisor/conf.d/supervisord.conf

COPY ./srcs/telegraf.tar.gz  telegraf.tar.gz
RUN  tar xvf telegraf.tar.gz && \
     mv 'telegraf-1.16.0' telegraf
COPY srcs/telegraf.conf /etc/telegraf/telegraf.conf
ADD ./srcs/supervisor.conf /etc/supervisor.conf


RUN mkdir -p /var/www/html
RUN mkdir -p /usr/share/phpmyadmin/tmp
RUN chmod 777 -R /usr/share/phpmyadmin

RUN chown -R nobody.nobody /var/www/html && \
  chown -R nobody.nobody /run && \
  chown -R nobody.nobody /var/lib/nginx && \
  chown -R nobody.nobody /var/log/nginx


RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.1/phpMyAdmin-4.9.1-english.tar.gz
RUN tar xf phpMyAdmin-4.9.1-english.tar.gz && rm -rf phpMyAdmin-4.9.1-english.tar.gz
RUN mv phpMyAdmin-4.9.1-english /var/www/html/phpmyadmin
COPY srcs/config.inc.php /var/www/html/phpmyadmin

USER nobody
COPY --chown=nobody srcs/ /var/www/html/

EXPOSE 5000



CMD ["supervisord", "-c", "/etc/supervisor.conf"]

