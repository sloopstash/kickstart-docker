# Docker image to use.
FROM sloopstash/alma-linux-9:v1.1.1

# Install system packages.
RUN set -x \
  && dnf update -y \
  && dnf install -y wget vim net-tools gcc make tar git unzip sysstat tree initscripts bind-utils nc nmap \

# Install Supervisor.
RUN set -x \
  && dnf -y install epel-release
  && dnf -y install supervisor \
  && history -c

# Set default work directory.
WORKDIR /