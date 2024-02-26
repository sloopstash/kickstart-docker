# Docker image to use.
FROM sloopstash/base-rocky-linux-9:v1.1.1

# Install system packages.
RUN dnf install -y tcl

#Install the redis dependencies package
RUN set -x \
    && dnf -y install gcc zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel tk-devel libffi-devel

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

# Create Redis directories.
WORKDIR ../nunga
RUN set -x \
  && rm -rf redis-7.2.1* \
  && mkdir /opt/redis \
  && mkdir /opt/redis/data \
  && mkdir /opt/redis/log \
  && mkdir /opt/redis/conf \
  && history -c

# Set default work directory.
WORKDIR /opt/redis