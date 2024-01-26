# Docker image to use.
FROM sloopstash/base-alma-linux-9:v1.1.1

# Download and Install Nginx version 1.24.0
WORKDIR /tmp
RUN set -x \
  && wget https://rpmfind.net/linux/centos/8-stream/AppStream/x86_64/os/Packages/compat-openssl10-1.0.2o-4.el8.x86_64.rpm --quiet \
  && dnf install -y compat-openssl10-1.0.2o-4.el8.x86_64.rpm \
  && wget https://nginx.org/packages/rhel/7/x86_64/RPMS/nginx-1.24.0-1.el7.ngx.x86_64.rpm --quiet \
  && dnf install -y nginx-1.24.0-1.el7.ngx.x86_64.rpm \
  && rm nginx-1.24.0-1.el7.ngx.x86_64.rpm 
  && rm compat-openssl10-1.0.2o-4.el8.x86_64.rpm 

# Create App and Nginx directories.
RUN set -x \
  && mkdir /opt/app \
  && mkdir /opt/app/source \
  && mkdir /opt/nginx \
  && mkdir /opt/nginx/log \
  && history -c

# Set default work directory.
WORKDIR /opt/nginx
