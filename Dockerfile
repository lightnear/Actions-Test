FROM zabbix/zabbix-server-mysql:ubuntu-5.0-latest
LABEL maintainer="lightnear<lightnear@qq.com>"

ENV TZ=Asia/Shanghai
ENV LANG en_US.utf8

USER root

RUN sed -i 's|archive.ubuntu.com|mirrors.aliyun.com|g' /etc/apt/sources.list \
    && sed -i 's|security.ubuntu.com|mirrors.aliyun.com|g' /etc/apt/sources.list \
    && apt update && DEBIAN_FRONTEND=noninteractive \
    && apt install -y tzdata \
    && ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone \
    && dpkg-reconfigure --frontend noninteractive tzdata \
    && apt install -y locales \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
    && apt install -y openssh-client rsync curl wget sudo git bzip2 \
    && apt install -y bc snmp snmp-mibs-downloader ipmitool iperf3 \
    && apt-get install -y python3-pip \
    && pip3 install --upgrade pip \
    && apt-get -y remove python3-pip \
    && rm -rf /var/lib/apt/lists/* \
    && pip install requests \
    && pip install --upgrade requests

ENTRYPOINT ["/usr/bin/tini", "--", "/usr/bin/docker-entrypoint.sh"]

USER 1997

CMD ["/usr/sbin/zabbix_server", "--foreground", "-c", "/etc/zabbix/zabbix_server.conf"]
