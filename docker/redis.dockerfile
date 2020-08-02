# use base image.
FROM sloopstash/amazonlinux:v1

# install system packages.
RUN yum install -y tcl

# download and extract redis.
WORKDIR /tmp
RUN set -x \
  && wget http://download.redis.io/releases/redis-2.8.19.tar.gz --quiet \
  && tar xvzf redis-2.8.19.tar.gz > /dev/null

# compile and install redis.
WORKDIR redis-2.8.19
RUN set -x \
  && make distclean \
  && make \
  && make install

# create necessary directories.
WORKDIR ../
RUN set -x \
  && rm -rf redis-2.8.19* \
  && mkdir /opt/redis \
  && mkdir /opt/redis/data \
  && mkdir /opt/redis/conf \
  && mkdir /opt/redis/log \
  && history -c

# set default work directory.
WORKDIR /opt/redis
