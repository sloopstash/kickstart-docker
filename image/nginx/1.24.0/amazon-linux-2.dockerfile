# Docker image to use.
FROM sloopstash/base:v1.1.1

# Install Nginx.
WORKDIR /tmp
RUN set -x \
  && wget https://nginx.org/packages/rhel/7/x86_64/RPMS/nginx-1.24.0-1.el7.ngx.x86_64.rpm --quiet \
  && yum install -y nginx-1.24.0-1.el7.ngx.x86_64.rpm \
  && rm -f nginx-1.24.0-1.el7.ngx.x86_64.rpm

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
