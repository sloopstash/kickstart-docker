# Docker image to use.
FROM sloopstash/base-alma-linux-8:v1.1.1

#Install dependencies packages of Python
RUN set -x \
  && dnf -y install zlib-devel bzip2-devel xz-devel readline-devel gdbm-devel libffi-devel libuuid-devel sqlite-devel

# Download and extract the source code of Python 3.12.0 and OpenSSL
WORKDIR /tmp
RUN set -x \
  && wget https://www.openssl.org/source/old/1.1.1/openssl-1.1.1v.tar.gz  --quiet \
  && tar -xzf openssl-1.1.1v.tar.gz \
  && wget https://www.python.org/ftp/python/3.12.0/Python-3.12.0.tar.xz \
  && tar xvf Python-3.12.0.tar.xz

# Compile and install OpenSSL.
WORKDIR openssl-1.1.1v
RUN set -x \
  && ./config --prefix=/usr/local/lib/openssl --libdir=lib --openssldir=/etc/ssl \
  && make depend \
  && make \
  && make install_sw

# Build and Install Python packages.
WORKDIR ../Python-3.12.0
RUN set -x \
  && ./configure --enable-optimizations \
       --with-openssl=/usr/local/lib/openssl \
       --with-openssl-rpath=auto \
       --enable-loadable-sqlite-extensions \
  && make altinstall \
  && ln -f -s /usr/local/bin/python3.12 /usr/bin/python

# Install Python dependent packages to start app.
RUN set -x \
  && pip3 install flask==0.12.4 \
  && pip3 install redis==2.10.6 \
  && pip3 install elastic-apm[flask]==3.0.5

# Create App directories.
RUN set -x \
  && rm -rf openssl-1.1.1v* \
  && rm -rf Python-3.12.0* \
  && mkdir /opt/app \
  && mkdir /opt/app/source \
  && mkdir /opt/app/log \
  && history -c

# Set default work directory.
WORKDIR /opt/app
