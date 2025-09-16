# Docker image to use.
FROM --platform=linux/amd64 sloopstash/base:v1.1.1 AS install_nginx_amd64

# Install Nginx on amd64 platform.
WORKDIR /tmp
RUN set -x \
  && wget https://nginx.org/packages/rhel/7/x86_64/RPMS/nginx-1.24.0-1.el7.ngx.x86_64.rpm --quiet \
  && yum install -y nginx-1.24.0-1.el7.ngx.x86_64.rpm \
  && rm -f nginx-1.24.0-1.el7.ngx.x86_64.rpm

# Docker image to use.
FROM --platform=linux/arm64 sloopstash/base:v1.1.1 AS install_nginx_arm64

# Install Nginx on arm64 platform.
WORKDIR /tmp
RUN set -x \
  && wget https://nginx.org/packages/rhel/7/aarch64/RPMS/nginx-1.24.0-1.el7.ngx.aarch64.rpm --quiet \
  && yum install -y nginx-1.24.0-1.el7.ngx.aarch64.rpm \
  && rm -f nginx-1.24.0-1.el7.ngx.aarch64.rpm

# Final Docker image setup.
FROM install_nginx_${TARGETARCH}

# Create App and Nginx directories.
RUN set -x \
  && mkdir /opt/app \
  && mkdir /opt/app/source \
  && mkdir /opt/nginx \
  && mkdir /opt/nginx/log \
  && mkdir /opt/nginx/conf \
  && mkdir /opt/nginx/script \
  && mkdir /opt/nginx/system \
  && touch /opt/nginx/log/access.log \
  && touch /opt/nginx/log/error.log \
  && touch /opt/nginx/conf/server.conf \
  && touch /opt/nginx/conf/app.conf \
  && touch /opt/nginx/system/server.pid \
  && touch /opt/nginx/system/supervisor.ini \
  && ln -s /opt/nginx/conf/app.conf /etc/nginx/conf.d/app.conf \
  && ln -s /opt/nginx/system/supervisor.ini /etc/supervisord.d/nginx.ini \
  && history -c

# Set default work directory.
WORKDIR /opt/nginx