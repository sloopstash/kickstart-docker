# Docker image to use.
FROM almalinux:9

# Install system packages.
RUN set -x \
  && dnf update -y \
  # && dnf install -y epel-release \
  && dnf install -y wget vim net-tools gcc make tar git unzip sysstat tree initscripts bind-utils nc nmap logrotate crontabs \
  && dnf install -y python-devel python-pip python-setuptools \
  && dnf clean all \
  && rm -rf /var/cache/dnf

# Install Supervisor.
RUN set -x \
  && pip install supervisor \
  && mkdir /etc/supervisord.d \
  && history -c

# Set default work directory.
WORKDIR /
