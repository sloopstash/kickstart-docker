# Docker image to use.
FROM sloopstash/base:v1.1.1

# Contribution & Support
MAINTAINER SloopStash

# Install system packages.
RUN set -x \
  && apt install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev wget libbz2-dev

# Download and extract Python.
WORKDIR /tmp
RUN set -x \
  && wget https://www.python.org/ftp/python/3.12.0/Python-3.12.0.tgz --quiet \
  && tar xvzf tar -xf Python-3.12.0.tgz > /dev/null

# Compile and install Python.
WORKDIR Python-3.12.*/
RUN set -x \
  && ./configure --enable-optimizations \
  && make \
  && make altinstall

# Create App directories.
WORKDIR ../
RUN set -x \
  && rm -rf Python-3.12.0* \
  && mkdir /opt/app \
  && mkdir /opt/app/source \
  && mkdir /opt/app/log \
  && history -c

# Set default work directory.
WORKDIR /opt/app