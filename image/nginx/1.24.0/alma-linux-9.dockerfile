# Docker image to use.
FROM sloopstash/base-alma-linux-9:v1.1.1

# Install system packages.
RUN dnf install -y pcre-devel pcre2-devel zlib-devel

# Download source code of Nginx 1.24.0 and extract
WORKDIR /tmp
RUN set -x \
  && wget http://nginx.org/download/nginx-1.24.0.tar.gz --quiet \
  && tar xvzf nginx-1.24.0.tar.gz > /dev/null

# Compile and install Nginx.
WORKDIR nginx-1.24.0
RUN set -x \
  && ./configure --prefix=/usr/local/nginx \
  && make \
  && make install

# Create Nginx directories.
WORKDIR ../
RUN set -x \
  && rm -rf nginx-1.24.0* \
  && ln -s /usr/local/nginx /opt/ \
  && history -c

# Set default work directory.
WORKDIR /opt/nginx