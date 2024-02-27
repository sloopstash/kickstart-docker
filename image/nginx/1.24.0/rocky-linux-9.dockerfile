# Docker image to use.
FROM sloopstash/base-rocky-linux-9:v1.1.1

# Install necessary build dependencies
RUN set -x \
    && dnf install -y wget tar gcc make pcre-devel zlib-devel

# Download, extract, compile, and install Nginx
WORKDIR /tmp
RUN set -x \
    && wget https://nginx.org/download/nginx-1.24.0.tar.gz --quiet \
    && tar xvzf nginx-1.24.0.tar.gz \
    && cd nginx-1.24.0 \
    && ./configure \
    && make \
    && make install \
    && cd /tmp \
    && rm -rf nginx-1.24.0 nginx-1.24.0.tar.gz

# Create App and Nginx directories.
RUN set -x \
  && mkdir -p /opt/app/source \
  && mkdir -p /opt/nginx/log

# Set default work directory.
WORKDIR /opt/nginx

# Clean up unnecessary build dependencies
RUN set -x \
    && dnf remove -y wget tar gcc make pcre-devel zlib-devel \
    && dnf clean all

