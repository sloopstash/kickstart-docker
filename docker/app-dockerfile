# use base image.
FROM sloopstash/amazonlinux:v1

# install nginx.
RUN set -x \
  && wget https://nginx.org/packages/rhel/7/x86_64/RPMS/nginx-1.14.0-1.el7_4.ngx.x86_64.rpm --quiet \
  && yum install -y nginx-1.14.0-1.el7_4.ngx.x86_64.rpm \
  && rm nginx-1.14.0-1.el7_4.ngx.x86_64.rpm

# install python packages.
RUN set -x \
  && pip install flask==0.12.4 \
  && pip install redis==2.10.6 \
  && pip install elastic-apm[flask]==3.0.5 \
  && mkdir /opt/app \
  && history -c

# set default work directory.
WORKDIR /opt/app
