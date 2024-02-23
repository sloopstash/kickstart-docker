# Docker image to use.
FROM sloopstash/base-rocky-linux-9:v1.1.1

# Download, extract, compile, and install Nginx
RUN set -x \
    && wget https://nginx.org/download/nginx-1.24.0.tar.gz --quiet \
    && tar xvzf nginx-1.24.0.tar.gz > /dev/null \
    && cd nginx-1.24.0 \
    && ./configure \
    && make \
    && make install

# Create App and Nginx directories.
RUN set -x \
  && mkdir -p /opt/app \
  && mkdir -p /opt/app/source \
  && mkdir -p /opt/nginx \
  && mkdir -p /opt/nginx/log \
  && history -c

# Set default work directory.
WORKDIR /opt/nginx