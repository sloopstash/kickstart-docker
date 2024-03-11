# Docker image to use.
FROM sloopstash/amazon-linux-2-base:v1.1.1

# Install system packages.
RUN yum update -y && \
    yum groupinstall -y "Development Tools" && \
    yum install -y amazon-linux-extras wget vim net-tools gcc make tar git unzip sysstat tree initscripts bind-utils nc nmap libxml2-devel sqlite-devel.x86_64

# Download and Extract PHP 
WORKDIR /tmp
RUN set -x \
  && wget https://www.php.net/distributions/php-8.3.3.tar.gz --quiet \
  && tar -xvzf php-8.3.3.tar.gz > /dev/null
WORKDIR /php-8.3.3

# Configure the PHP build process, build PHP, and install PHP
RUN ./configure && \
    make && \
    make install

# Create App directories.
RUN set -x \
  && mkdir /opt/app \
  && mkdir /opt/app/source \
  && mkdir /opt/app/log \
  && history -c

  # Set default work directory.
WORKDIR /opt/app
