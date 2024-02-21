# Docker image to use.
FROM sloopstash/amazon-linux-2-base:v1.1.1

# Install system packages.
RUN yum update -y && \
    yum groupinstall -y "Development Tools" && \
    yum install -y amazon-linux-extras wget vim net-tools gcc make tar git unzip sysstat tree initscripts bind-utils nc nmap

# Install Java
RUN amazon-linux-extras install -y java-openjdk11

# Verify Java installation
RUN java -version

# Create App directories.
RUN set -x \
  && mkdir /opt/app \
  && mkdir /opt/app/source \
  && mkdir /opt/app/log \
  && history -c

# Set default work directory.
WORKDIR /opt/app
