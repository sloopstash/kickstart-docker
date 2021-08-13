# Docker image to use.
FROM amazonlinux:2

# Install system packages.
RUN set -x \
  && yum update -y \
  && yum install -y wget vim initscripts gcc make tar unzip net-tools bind-utils nc nmap \
  && yum install -y python-devel python-pip python-setuptools \
  && easy_install supervisor \
  && mkdir /etc/supervisord.d \
  && history -c
