# Docker image to use.
FROM sloopstash/base:v1.1.1

# Install system packages.
RUN yum install -y zlib-devel libicu-devel readline-devel

# Download and extract PostgreSQL.
WORKDIR /tmp
RUN set -x \
  && wget https://ftp.postgresql.org/pub/source/v16.4/postgresql-16.4.tar.gz --quiet \
  && tar xvzf postgresql-16.4.tar.gz > /dev/null

# Compile and install PostgreSQL.
WORKDIR postgresql-16.4
RUN set -x \
  && ./configure \
  && make \
  && make install
ENV PATH=/usr/local/pgsql/bin:$PATH

# Create PostgreSQL directories.
WORKDIR ../
RUN set -x \
  && rm -rf postgresql-16.4* \
  && mkdir /opt/postgresql \
  && mkdir /opt/postgresql/data \
  && mkdir /opt/postgresql/log \
  && mkdir /opt/postgresql/conf \
  && mkdir /opt/postgresql/script \
  && mkdir /opt/postgresql/system \
  && touch /opt/postgresql/system/server.pid \
  && touch /opt/postgresql/system/supervisor.ini \
  && ln -s /opt/postgresql/system/supervisor.ini /etc/supervisord.d/postgresql.ini \
  && history -c

# Set default work directory.
WORKDIR /opt/postgresql
