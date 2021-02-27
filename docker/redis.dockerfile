# Docker image to use.
FROM sloopstash/amazonlinux:v1

# Install system packages.
RUN yum install -y tcl

# Download and extract Redis.
WORKDIR /tmp
RUN set -x \
  && wget http://download.redis.io/releases/redis-2.8.19.tar.gz --quiet \
  && tar xvzf redis-2.8.19.tar.gz > /dev/null

# Compile and install Redis.
WORKDIR redis-2.8.19
RUN set -x \
  && make distclean \
  && make \
  && make install

# Create necessary directories.
WORKDIR ../
RUN set -x \
  && rm -rf redis-2.8.19* \
  && mkdir /opt/redis \
  && mkdir /opt/redis/data \
  && mkdir /opt/redis/conf \
  && mkdir /opt/redis/log \
  && history -c

# Set default work directory.
WORKDIR /opt/redis
