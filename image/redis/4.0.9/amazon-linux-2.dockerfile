# Docker image to use.
FROM sloopstash/base:v1.1.1

# Install system packages.
RUN yum install -y tcl

# Download and extract Redis.
WORKDIR /tmp
RUN set -x \
  && wget http://download.redis.io/releases/redis-4.0.9.tar.gz --quiet \
  && tar xvzf redis-4.0.9.tar.gz > /dev/null

# Compile and install Redis.
WORKDIR redis-4.0.9
RUN set -x \
  && make distclean \
  && make \
  && make install

# Create Redis directories.
WORKDIR ../
RUN set -x \
  && rm -rf redis-4.0.9* \
  && mkdir /opt/redis \
  && mkdir /opt/redis/data \
  && mkdir /opt/redis/log \
  && mkdir /opt/redis/conf \
  && mkdir /opt/redis/script \
  && mkdir /opt/redis/system \
  && touch /opt/redis/system/server.pid \
  && touch /opt/redis/system/supervisor.ini \
  && ln -s /opt/redis/system/supervisor.ini /etc/supervisord.d/redis.ini \
  && history -c

# Set default work directory.
WORKDIR /opt/redis
