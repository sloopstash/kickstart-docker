# Docker image to use.
FROM amazonlinux:2

# Install system packages.
RUN set -x \
  && yum update -y \
  && yum install -y wget vim net-tools gcc make tar git unzip sysstat tree initscripts bind-utils nc nmap logrotate crontabs \
  && yum install -y python-devel python-pip python-setuptools

# Install Supervisor.
RUN set -x \
  && python -m pip install supervisor \
  && mkdir /etc/supervisord.d \
  && history -c

# Set default work directory.
WORKDIR /
