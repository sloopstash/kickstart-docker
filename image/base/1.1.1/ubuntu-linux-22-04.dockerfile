# Docker image to use.
FROM ubuntu:22.04

# Install system packages.
RUN set -x \
  && apt update \
  && apt upgrade -y \
  && apt install -y wget vim net-tools gcc make tar git unzip sysstat tree netcat nmap logrotate cron

# Install Supervisor.
RUN set -x \
  && apt install -y supervisor \
  && history -c

# Set default work directory.
WORKDIR /
