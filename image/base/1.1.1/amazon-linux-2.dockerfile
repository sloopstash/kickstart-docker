# Docker image to use.
FROM sloopstash/amazon-linux-2:v1.1.1

# Install system packages.
RUN set -x \
  && yum update -y \
  && yum install -y wget vim net-tools gcc make tar git unzip sysstat tree initscripts bind-utils nc nmap \
  && yum install -y python-devel python-pip python-setuptools

# Install Supervisor.
RUN set -x \
  && easy_install supervisor \
  && mkdir /etc/supervisord.d \
  && history -c

# Set default work directory.
WORKDIR /
