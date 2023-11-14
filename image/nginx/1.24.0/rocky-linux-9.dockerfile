#Docker image to use.
FROM base/rocky-linux-9:v1.1.1

# Install Nginx.
RUN set -x \
  && wget https://nginx.org/download/nginx-1.24.0.tar.gz --quiet \
  && tar xvzf nginx-1.24.0.tar.gz > /dev/null \
  && yum install -y nginx-1.24.0-1.el7.ngx.x86_64.rpm \
  && rm nginx-1.24.0-1.el7_4.ngx.x86_64.rpm

# Create App and Nginx directories.
RUN set -x \
  && mkdir -p /opt/app \
  && mkdir -p /opt/app/source \
  && mkdir -p /opt/nginx \
  && mkdir -p /opt/nginx/log \
  && history -c

# Set default work directory.
WORKDIR /opt/nginx