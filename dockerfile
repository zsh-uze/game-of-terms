FROM alpine
RUN set -e ;\
    apk update ;\
    apk upgrade ;\
    apk add openssh-server
CMD set -e ;\
    mkdir /run/sshd ;\
    chmod 0755 /run/sshd ;\
    /usr/sbin/sshd -D
