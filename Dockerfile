FROM ubuntu:latest

LABEL maintainer="Denis Galimov <galimovdi@gmail.com>"

RUN apt-get update &&\
    apt-get install -y wget locales openvpn iptables bash easy-rsa openvpn-auth-ldap openvpn-auth-radius pamtester && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
    cd /tmp && \
    wget -q https://github.com/OpenVPN/easy-rsa/releases/download/3.0.0/EasyRSA-3.0.0.tgz && \
    tar -xf EasyRSA-3.0.0.tgz $(tar -tf EasyRSA-3.0.0.tgz | grep -E 'easyrsa|vars|openssl|ca|client|server|COMMON') && \
    cp -rf EasyRSA-3.0.0/* /usr/share/easy-rsa/ && \
    mv -f /usr/share/easy-rsa/vars.example /usr/share/easy-rsa/vars && \
    rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

ENV LANG en_US.utf8
ENV OPENVPN /etc/openvpn
ENV EASYRSA /usr/share/easy-rsa
ENV EASYRSA_PKI $OPENVPN/pki
ENV EASYRSA_VARS_FILE $OPENVPN/vars
ENV EASYRSA_CRL_DAYS 3650

VOLUME ["/etc/openvpn"]

EXPOSE 1194/udp

CMD ["ovpn_run"]

ADD ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/* && \
    ln -s /usr/share/easy-rsa/easyrsa /usr/local/bin
