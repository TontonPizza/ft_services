FROM alpine

USER root

COPY srcs/install.sh /tmp/install.sh
COPY srcs/nginx.conf /etc/nginx/nginx.conf
COPY srcs/index.html /var/www/localhost/htdocs/index.html
COPY srcs/sshd_config /etc/ssh/sshd_config
COPY srcs/id_rsa.pub /etc/ssh/id_rsa.pub
COPY srcs/id_rsa /etc/ssh/id_rsa

COPY srcs/telegraf.conf ./etc/telegraf.conf

RUN chmod +x /tmp/install.sh

VOLUME [ “/sys/fs/cgroup” ] 

RUN sh /tmp/install.sh

EXPOSE 80 443 22

ENTRYPOINT /etc/init.d/telegraf start ; /etc/init.d/sshd start ; nginx -g "daemon off;"
