# Docker image to use.
FROM sloopstash/base-rocky-linux-8:v1.1.1

# Download and extract Redis 7.2.1
WORKDIR /tmp
RUN set -x \
&& wget https://download.redis.io/releases/redis-7.2.1.tar.gz --quiet \
&& tar xzf redis-7.2.1.tar.gz > /dev/null

# Compile and install Redis
WORKDIR cd redis-7.2.1
RUN set -x \
  && make \
  && make install

# Create Redis directories
RUN set -x \
  && mkdir -p /opt/redis/data \
  && mkdir -p /opt/redis/log \
  && mkdir -p /opt/redis/conf

# Set default work directory
WORKDIR /opt/redis
