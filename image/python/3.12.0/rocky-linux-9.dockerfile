# Docker image to use.
FROM sloopstash/base-rocky-linux-9:v1.1.1

#Install the Python dependencies package
RUN set -x \
    && dnf -y install gcc zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel tk-devel libffi-devel

# Download source code of Python 3.12.0 and extract
WORKDIR /tmp
RUN set -x \
   && wget https://www.python.org/ftp/python/3.12.0/Python-3.12.0.tar.xz --quiet \
   && tar xvf Python-3.12.0.tar.xz > /dev/null
   

# Build and Install Python packages.
WORKDIR Python-3.12.0
RUN set -x \
   && ./configure --enable-optimizations \
   && make altinstall \
   && ln -f -s /usr/local/bin/python3.12 /usr/bin/python \
   && rm -rf /tmp/Python-3.12.0* 

# Create App directories.
RUN set -x \
  && mkdir /opt/app \
  && mkdir /opt/app/source \
  && mkdir /opt/app/log \
  && history -c

# Set default work directory.
WORKDIR /opt/app