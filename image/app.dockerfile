# Docker image to use.
FROM sloopstash/amazonlinux:v1

# Install Nginx.
RUN set -x \
  && wget https://nginx.org/packages/rhel/7/x86_64/RPMS/nginx-1.14.0-1.el7_4.ngx.x86_64.rpm --quiet \
  && yum install -y nginx-1.14.0-1.el7_4.ngx.x86_64.rpm \
  && rm nginx-1.14.0-1.el7_4.ngx.x86_64.rpm

# Install Python packages.
RUN set -x \
  && pip install flask==0.12.4 \
  && pip install redis==2.10.6 \
  && pip install elastic-apm[flask]==3.0.5 \
  && mkdir /opt/app \
  && history -c

# Set default work directory.
WORKDIR /opt/app
