# Docker image to use.
FROM amazonlinux:2

# Install system packages.
RUN set -x \
  && yum update -y \
  && yum install -y wget vim net-tools initscripts gcc make tar bind-utils nc \
  && yum install -y python-devel python-pip python-setuptools \
  && easy_install supervisor \
  && mkdir /etc/supervisord.d \
  && history -c
