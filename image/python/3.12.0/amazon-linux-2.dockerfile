# Docker image to use.
FROM sloopstash/base:v1.1.1

#Install system packages.
RUN set -x \
  && yum -y install zlib-devel bzip2-devel xz-devel readline-devel gdbm-devel libffi-devel libuuid-devel sqlite-devel

# Download and extract OpenSSL and Python.
WORKDIR /tmp
RUN set -x \
  && wget https://www.openssl.org/source/old/1.1.1/openssl-1.1.1v.tar.gz  --quiet \
  && tar -xzf openssl-1.1.1v.tar.gz \
  && wget https://www.python.org/ftp/python/3.12.0/Python-3.12.0.tgz --quiet \
  && tar -xzf Python-3.12.0.tgz

# Compile and install OpenSSL.
WORKDIR openssl-1.1.1v
RUN set -x \
  && ./config --prefix=/usr/local/lib/openssl --libdir=lib --openssldir=/etc/ssl \
  && make depend \
  && make \
  && make install_sw

# Compile and install Python.
WORKDIR ../Python-3.12.0
RUN set -x \
  && ./configure \
       --enable-optimizations \
       --with-openssl=/usr/local/lib/openssl \
       --with-openssl-rpath=auto \
       --enable-loadable-sqlite-extensions \
  && make \
  && make altinstall \
  && ln -f -s /usr/local/bin/python3.12 /usr/bin/python

# Create App directories.
WORKDIR ../
RUN set -x \
  && rm -rf openssl-1.1.1v* \
  && rm -rf Python-3.12.0* \
  && mkdir /opt/app \
  && mkdir /opt/app/source \
  && mkdir /opt/app/log \
  && history -c

# Set default work directory.
WORKDIR /opt/app
