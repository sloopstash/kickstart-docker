# Docker image to use.
FROM sloopstash/base:v1.1.1

# Contribution & Support
MAINTAINER SloopStash

# Install system packages.
RUN yum install -y pcre-devel pcre2-devel zlib-devel

# Download and extract Nginx.
WORKDIR /tmp
RUN set -x \
  && wget wget http://nginx.org/download/nginx-1.24.0.tar.gz --quiet \
  && tar xvzf nginx-1.24.0.tar.gz > /dev/null

# Compile and install Redis.
WORKDIR nginx-1.24.0
RUN set -x \
  && ./configure --prefix=/usr/local/nginx \
  && make \
  && make install

# Create Redis directories.
WORKDIR ../
RUN set -x \
  && rm -rf nginx-1.24.0* \
  && ln -s /usr/local/nginx /opt/ \
  && history -c

# Set default work directory.
WORKDIR /opt/nginx
