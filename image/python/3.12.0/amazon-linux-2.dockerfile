# Docker image to use.
FROM sloopstash/base:v1.1.1

# Install system packages.
RUN set -x \
  && yum install -y bzip2-devel zlib-devel xz-devel libffi-devel gdbm-devel libuuid-devel sqlite-devel readline-devel

# Download and extract Python.
WORKDIR /tmp
RUN set -x \
  && wget https://www.python.org/ftp/python/3.12.0/Python-3.12.0.tgz --quiet \
  && tar xvzf Python-3.12.0.tgz > /dev/null

# Compile and install Python.
WORKDIR Python-3.12.0
RUN set -x \
  && ./configure --enable-optimizations \
  && make \
  && make install \
  && update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1 \
  && update-alternatives --install /usr/bin/python python /usr/local/bin/python3.12 2

# Create App directories.
WORKDIR ../
RUN set -x \
  && rm -rf Python-3.12.0* \
  && mkdir /opt/app \
  && mkdir /opt/app/source \
  && mkdir /opt/app/log \
  && mkdir /opt/app/system \
  && touch /opt/app/system/supervisor.ini \
  && ln -s /opt/app/system/supervisor.ini /etc/supervisord.d/app.ini \
  && history -c

# Set default work directory.
WORKDIR /opt/app
