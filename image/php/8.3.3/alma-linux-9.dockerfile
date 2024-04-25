# Docker image to use.
FROM sloopstash/base-alma-linux-9:v1.1.1
  
# Install the PHP 8.3.0 dependencies package
RUN set -x \
  && dnf -y install https://rpms.remirepo.net/enterprise/remi-release-9.rpm \
  && dnf module enable php:remi-8.3 -y \
  && dnf -y install gcc zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel tk-devel libffi-devel \
  && dnf clean all
  
# Download source code of php 8.3.0 and extract
WORKDIR /tmp
RUN set -x \
    && wget https://www.php.net/distributions/php-8.3.0.tar.xz --quiet \
    && tar xvf php-8.3.0.tar.xz > /dev/null \
    && rm php-8.3.0.tar.xz

# Build and Install PHP 8.3.0 Packages.
WORKDIR /tmp/php-8.3.0
RUN set -x \
    && ./configure --disable-fileinfo \
    && make \
    && make install \
    && rm -rf /tmp/php-8.3.0
    
# Create App directories.
RUN set -x \
   && mkdir -p /opt/app/php-8.3.0 \
   && mkdir -p /opt/app/source \
   && mkdir -p /opt/app/log \
   && history -c

# Set default work directory.
WORKDIR /opt/app