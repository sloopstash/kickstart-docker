# Docker image to use.
FROM almalinux:8

# Install system packages and Supervisor.
RUN set -x \
  && dnf update -y \
  && dnf install -y epel-release \
  && dnf install -y wget vim net-tools gcc make tar git unzip sysstat tree initscripts bind-utils nc nmap logrotate crontabs \
  && dnf install -y supervisor \
  && dnf clean all \
  && rm -rf /var/cache/dnf \
  && history -c

# Set default work directory.
WORKDIR /
