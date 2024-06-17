# Docker image to use.
FROM sloopstash/base:v1.1.1

# Install system packages.
RUN set -x \
  && yum install -y amazon-linux-extras libxml2-devel sqlite-devel

# Download and extract PHP.
WORKDIR /tmp
RUN set -x \
  && wget https://www.php.net/distributions/php-8.3.3.tar.gz --quiet \
  && tar xvzf php-8.3.3.tar.gz > /dev/null

# Compile and install PHP.
WORKDIR php-8.3.3
RUN set -x \
  && ./configure \
  && make \
  && make install

# Create App directories.
WORKDIR ../
RUN set -x \
  && rm -rf php-8.3.3* \
  && mkdir /opt/app \
  && mkdir /opt/app/source \
  && mkdir /opt/app/log \
  && mkdir /opt/app/system \
  && touch /opt/app/system/supervisor.ini \
  && ln -s /opt/app/system/supervisor.ini /etc/supervisord.d/app.ini \
  && history -c

# Set default work directory.
WORKDIR /opt/app
