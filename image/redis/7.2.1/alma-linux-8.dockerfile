# Docker image to use.
FROM sloopstash/base-alma-linux-8:v1.1.1

# Download and extract Redis 7.2.1
WORKDIR /tmp
RUN set -x \
  && wget http://download.redis.io/releases/redis-7.2.1.tar.gz --quiet \
  && tar xvzf redis-7.2.1.tar.gz > /dev/null

# Compile and install Redis
WORKDIR redis-7.2.1
RUN set -x \
  && make distclean \
  && make \
  && make install

# Create Redis directories.
WORKDIR ../
RUN set -x \
  && rm -rf redis-7.2.1* \
  && mkdir /opt/redis \
  && mkdir /opt/redis/data \
  && mkdir /opt/redis/log \
  && mkdir /opt/redis/conf \
  && history -c

# Set default work directory.
WORKDIR /opt/redis
