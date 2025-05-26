# Docker image to use.
FROM sloopstash/base:v1.2.1 AS install_system_packages

# Install system packages.
RUN set -x \
  && yum install -y zlib-devel libicu-devel readline-devel \
  && yum clean all \
  && rm -rf /var/cache/yum

# Intermediate Docker image to use.
FROM install_system_packages AS install_postgresql

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

# Docker image to use.
FROM sloopstash/base:v1.2.1 AS create_postgresql_directories

# Create PostgreSQL directories.
RUN set -x \
  && mkdir /opt/postgresql \
  && mkdir /opt/postgresql/data \
  && mkdir /opt/postgresql/log \
  && mkdir /opt/postgresql/conf \
  && mkdir /opt/postgresql/script \
  && mkdir /opt/postgresql/system \
  && touch /opt/postgresql/system/server.pid \
  && touch /opt/postgresql/system/supervisor.ini

# Intermediate Docker image to use.
FROM install_system_packages AS finalize_postgresql_oci_image

# Create system user for PostgreSQL.
RUN useradd -m postgresql

# Copy PostgreSQL installation.
COPY --from=install_postgresql /usr/local/pgsql /usr/local/pgsql
ENV PATH=/usr/local/pgsql/bin:$PATH

# Copy PostgreSQL directories.
COPY --from=create_postgresql_directories /opt/postgresql /opt/postgresql

# Symlink Supervisor configuration.
RUN set -x \
  && ln -s /opt/postgresql/system/supervisor.ini /etc/supervisord.d/postgresql.ini \
  && chown -R postgresql:postgresql /opt/postgresql \
  && history -c

# Set default work directory.
WORKDIR /opt/postgresql
