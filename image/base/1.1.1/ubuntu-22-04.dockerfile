# Docker image to use.
FROM sloopstash/ubuntu-22-04:v1.1.1

# Install system packages.
RUN set -x \
  && apt-get update -y \
  && apt-get install -y wget vim net-tools gcc make tar git unzip sysstat tree 

# Install Supervisor.
RUN set -x \
  && apt-get install -y supervisor \
  && mkdir /etc/supervisord.d  

# Set default work directory.
WORKDIR /