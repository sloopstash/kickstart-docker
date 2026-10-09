# Docker image to use.
FROM sloopstash/base:v1.2.1 AS install_mysql

# Download and install MySQL 8.0.41 binary.
WORKDIR /tmp
RUN set -x \
  && yum update -y \
  && yum install -y wget xz libaio numactl-libs ncurses-compat-libs \
  && yum clean all \
  && rm -rf /var/cache/yum \
  && wget https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-8.0.41-linux-glibc2.17-x86_64.tar.xz \
  && tar -xJf mysql-8.0.41-linux-glibc2.17-x86_64.tar.xz \
  && mv mysql-8.0.41-linux-glibc2.17-x86_64 /usr/local/mysql

# Create MySQL directories.
FROM sloopstash/base:v1.2.1 AS create_mysql_directories

RUN set -x \
  && mkdir -p /opt/mysql/data \
  && mkdir -p /opt/mysql/log \
  && mkdir -p /opt/mysql/conf \
  && mkdir -p /opt/mysql/script \
  && mkdir -p /opt/mysql/system \
  && touch /opt/mysql/system/server.pid \
  && touch /opt/mysql/system/supervisor.ini

# Final image.
FROM sloopstash/base:v1.2.1

# Install runtime dependencies.
RUN yum install -y libaio numactl-libs ncurses-compat-libs \
  && yum clean all \
  && rm -rf /var/cache/yum

# Create MySQL user.
RUN useradd -m mysql

# Copy MySQL installation.
COPY --from=install_mysql /usr/local/mysql /usr/local/mysql

ENV PATH=/usr/local/mysql/bin:$PATH

# Copy MySQL directories.
COPY --from=create_mysql_directories /opt/mysql /opt/mysql

# Configure permissions.
RUN set -x \
  && ln -s /opt/mysql/system/supervisor.ini /etc/supervisord.d/mysql.ini \
  && chown -R mysql:mysql /opt/mysql \
  && chown -R mysql:mysql /usr/local/mysql

# Default working directory.
WORKDIR /opt/mysql