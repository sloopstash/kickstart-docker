# Docker image to use.
FROM rockylinux:8

# Install system packages.
RUN set -x \
  && dnf update -y \
  # && dnf install -y epel-release \
  && dnf install -y wget vim net-tools gcc make tar git unzip sysstat tree initscripts bind-utils nc nmap logrotate crontabs \
  && dnf install -y python3-devel python3-pip python3-setuptools \
  && dnf clean all \
  && rm -rf /var/cache/dnf

# Install Supervisor.
RUN set -x \
  && pip3 install supervisor \
  && mkdir /etc/supervisord.d \
  && history -c

# Set default work directory.
WORKDIR /
