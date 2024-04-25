# Docker image to use.
FROM sloopstash/base:v1

# Install system packages.
RUN set -x \
  && amazon-linux-extras enable epel \
  && yum install -y epel-release \
  && yum install -y https://dev.mysql.com/get/mysql80-community-release-el7-5.noarch.rpm

# Switch work directory.
WORKDIR /tmp

# Download source code.
RUN set -x \
  && wget https://downloads.percona.com/downloads/Percona-Server-innovative-release/Percona-Server-8.2.0-1/binary/redhat/8/x86_64/Percona-Server-8.2.0-1-r582ebeef-el8-x86_64-bundle.tar \  
  && tar xvf Percona-Server-8.2.0-1-r582ebeef-el8-x86_64-bundle.tar \
  && ls *.rpm \
  && wget https://repo.percona.com/yum/release/8/RPMS/x86_64/jemalloc-3.6.0-1.el8.x86_64.rpm \
  && mkdir -p /opt/source/Devel/SLST/OpenSource/kickstart-docker/image/mysql/8.2/context \
  && cp percona-server-server-8.2.0-1.1.el8.x86_64.rpm /opt/source/Devel/SLST/OpenSource/kickstart-docker/image/mysql/8.2/context

# Install MySQL.
RUN set -x \
  && yum update -y yum \
  && yum install -y yum-utils \
  && yum-config-manager --disable mysql \
  && rpm -ivh https://repo.percona.com/yum/percona-release-latest.noarch.rpm \
  && percona-release enable-only ps-8x-innovation release \
  && percona-release enable tools release \
  && yum install -y percona-server-server

  # Create MySQL directories.
RUN set -x \
  && mkdir -p /opt/MySQL/{Data,Log,Conf,Script,System} \
  && touch /opt/MySQL/Conf/{Server.conf,Server-Safe.conf} \
  && touch /opt/MySQL/System/{Process.pid,Supervisor.ini,Logrotate.conf} \
  && mkdir -p /etc/percona-server.conf.d/ \
  && ln -s /opt/MySQL/Conf/Server.conf /etc/percona-server.conf.d/mysqld.cnf \
  && ln -s /opt/MySQL/Conf/Server-Safe.conf /etc/percona-server.conf.d/mysqld_safe.cnf \
  && ln -s /opt/MySQL/System/Supervisor.ini /etc/supervisord.d/mysql.ini \
  && ln -s /opt/MySQL/System/Logrotate.conf /etc/logrotate.d/mysql.conf \
  && history -c

# Switch work directory.
WORKDIR /opt/MySQL