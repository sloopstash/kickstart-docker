# Docker image to use.
FROM sloopstash/base-ubuntu-22-04:v1.1.1


# Contribution & Support
MAINTAINER SloopStash

# Install Nginx.
RUN set -x \
  && wget https://nginx.org/packages/ubuntu/pool/nginx/n/nginx/nginx_1.24.0-1~jammy_amd64.deb  --quiet \
  && dpkg -i nginx_1.24.0-1~jammy_amd64.deb \
  && rm nginx_1.24.0-1~jammy_amd64.deb

# Create App and Nginx directories.
RUN set -x \
  && mkdir /opt/app \
  && mkdir /opt/app/source \
  && mkdir /opt/nginx \
  && mkdir /opt/nginx/log \
  && history -c

# Set default work directory.
WORKDIR /opt/nginx
