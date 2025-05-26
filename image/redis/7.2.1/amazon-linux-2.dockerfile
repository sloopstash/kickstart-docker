# Docker image to use.
FROM sloopstash/base:v1.2.1 AS install_system_packages

# Install system packages.
RUN set -x \
  && yum install -y tcl \
  && yum clean all \
  && rm -rf /var/cache/yum

# Intermediate Docker image to use.
FROM install_system_packages AS install_redis

# Download and extract Redis.
WORKDIR /tmp
RUN set -x \
  && wget http://download.redis.io/releases/redis-7.2.1.tar.gz --quiet \
  && tar xvzf redis-7.2.1.tar.gz > /dev/null

# Compile and install Redis.
WORKDIR redis-7.2.1
RUN set -x \
  && make distclean \
  && make \
  && make install

# Docker image to use.
FROM sloopstash/base:v1.2.1 AS create_redis_directories

# Create Redis directories.
RUN set -x \
  && mkdir /opt/redis \
  && mkdir /opt/redis/data \
  && mkdir /opt/redis/log \
  && mkdir /opt/redis/conf \
  && mkdir /opt/redis/script \
  && mkdir /opt/redis/system \
  && touch /opt/redis/system/server.pid \
  && touch /opt/redis/system/supervisor.ini

# Docker image to use.
FROM sloopstash/base:v1.2.1 AS finalize_redis_oci_image

# Copy Redis binary executable programs.
COPY --from=install_redis /usr/local/bin/redis-server /usr/local/bin/redis-server
COPY --from=install_redis /usr/local/bin/redis-cli /usr/local/bin/redis-cli

# Copy Redis directories.
COPY --from=create_redis_directories /opt/redis /opt/redis

# Symlink Supervisor configuration.
RUN set -x \
  && ln -s /opt/redis/system/supervisor.ini /etc/supervisord.d/redis.ini \
  && history -c

# Set default work directory.
WORKDIR /opt/redis
