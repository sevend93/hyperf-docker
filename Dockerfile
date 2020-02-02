FROM hyperf/hyperf:7.3-alpine-v3.9-cli

ENV SSH_ENABLE_ROOT=true
ENV SSH_ENABLE_PASSWORD_AUTH=true

COPY entry.sh /entry.sh
COPY setpasswd.sh /etc/entrypoint.d/setpasswd.sh

RUN apk update && \
    apk add --no-cache bash git openssh rsync augeas shadow php7-imagick expect vim && \
    deluser $(getent passwd 33 | cut -d: -f1) && \
    delgroup $(getent group 33 | cut -d: -f1) 2>/dev/null || true && \
    mkdir -p ~root/.ssh /etc/authorized_keys && chmod 700 ~root/.ssh/ && \
    augtool 'set /files/etc/ssh/sshd_config/AuthorizedKeysFile ".ssh/authorized_keys /etc/authorized_keys/%u"' && \
    echo -e "Port 22\n" >> /etc/ssh/sshd_config && \
    cp -a /etc/ssh /etc/ssh.cache && \
    rm -rf /var/cache/apk/*
    
RUN wget https://github.com/composer/composer/releases/download/1.9.1/composer.phar && \
    chmod u+x composer.phar && \
    mv composer.phar /usr/local/bin/composer && \
    chmod +x /entry.sh && \
    chmod +x /etc/entrypoint.d/setpasswd.sh

EXPOSE 22
EXPOSE 9501
EXPOSE 9502
EXPOSE 9503
EXPOSE 9504

ENTRYPOINT ["/entry.sh"]

CMD ["/usr/sbin/sshd", "-D", "-e", "-f", "/etc/ssh/sshd_config"]
