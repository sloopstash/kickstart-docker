# Docker image to use.
FROM sloopstash/base:v1.1.1

# Install necessary packages for PostgreSQL build.
RUN set -x \
  && yum update -y \
  && yum install -y gcc-c++ readline-devel zlib-devel bzip2-devel openssl-devel icu-devel \
  && yum clean all

# Install PostgreSQL from source.
WORKDIR /tmp
RUN set -x \
  && wget https://ftp.postgresql.org/pub/source/v16.4/postgresql-16.4.tar.gz --quiet \
  && tar xvzf postgresql-16.4.tar.gz > /dev/null \
  && cd postgresql-16.4 \
  && ./configure --without-icu \
  && make \
  && make install \
  && rm -rf /tmp/postgresql-16.4*

# Create PostgreSQL directories.
RUN set -x \
  && mkdir -p /opt/postgresql/data \
  && mkdir /opt/postgresql/log \
  && mkdir /opt/postgresql/conf \
  && mkdir /opt/postgresql/script \
  && mkdir /opt/postgresql/system \
  && touch /opt/postgresql/system/node.pid \
  && touch /opt/postgresql/system/supervisor.ini \
  && ln -s /opt/postgresql/system/supervisor.ini /etc/supervisord.d/postgresql.ini \
  && history -c

# Ensure PostgreSQL binaries are in PATH.
ENV PATH="/usr/local/pgsql/bin:${PATH}"

# Set default work directory.
WORKDIR /opt/postgresql
