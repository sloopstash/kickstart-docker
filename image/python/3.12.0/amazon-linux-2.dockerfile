# Docker image to use.
FROM sloopstash/base:v1.1.1

# Contribution & Support
MAINTAINER SloopStash

#Install the Python dependencies package

RUN set -x \
    && yum -y install gcc zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel tk-devel libffi-devel

# Download and build Python 3.12.0
WORKDIR /tmp
RUN set -x \
    && wget https://www.python.org/ftp/python/3.12.0/Python-3.12.0.tgz --quiet \ 
    && tar -xzf Python-3.12.0.tgz > /dev/null

# Compile and install Redis.
RUN set -x \
    && cd Python-3.12.0 \
    && ./configure --enable-optimizations \
    && make altinstall \
    && rm -rf /tmp/Python-3.12.0*

# Set the default Python version
RUN ln -s /usr/local/bin/python3.12 /usr/local/bin/python

# Print Python version to verify installation
RUN python --version
