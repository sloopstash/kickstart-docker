# Docker image to use.
FROM rockylinux:8

# Install system packages.
RUN set -x \
  && dnf update -y \
  && dnf install -y epel-release \
  && dnf install -y wget vim net-tools gcc make tar git unzip sysstat tree initscripts bind-utils nc nmap logrotate crontabs

# Install Supervisor.
RUN set -x \
  && dnf install -y supervisor \
  && history -c

# Set default work directory.
WORKDIR /
