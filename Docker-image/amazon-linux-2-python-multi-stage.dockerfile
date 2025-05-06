# Docker base image to use.
FROM sloopstash/base:v1.1.1 AS install_system_package

# Install system packages.
RUN set -x \
  && yum install -y bzip2-devel zlib-devel xz-devel libffi-devel gdbm-devel libuuid-devel sqlite-devel readline-devel

# Download and install python 3.12.0
FROM install_system_package AS install_python

# Set working directory
WORKDIR /tmp

# Download and extract python package 
RUN set -x \
  && wget https://www.python.org/ftp/python/3.12.0/Python-3.12.0.tgz --quiet \
  && tar xvzf Python-3.12.0.tgz > /dev/null

# Compile and install python
# Set work directory
WORKDIR Python-3.12.0
RUN set -x \
  && ./configure --enable-optimizations \
  && make \
  && make install \
  && update-alternatives --install /usr/bin/python python /usr/local/bin/python3.12 2

# Create App directories
FROM sloopstash/base:v1.1.1 AS app_directories_creation
RUN set -x \
  && mkdir /opt/app \
  && mkdir /opt/app/source \
  && mkdir /opt/app/log \
  && mkdir /opt/app/system \
  && touch /opt/app/system/supervisor.ini 

# Finalize the image build
FROM sloopstash/base:v1.1.1 AS finalize_image_build
COPY --from=install_python /usr/local/bin/pip3.12 /usr/local/bin/pip3.12
COPY --from=install_python /usr/local/bin/python3.12 /usr/local/bin/python3.12
COPY --from=install_python /usr/local/lib/python3.12 /usr/local/lib/python3.12

COPY --from=app_directories_creation /opt/app /opt/app

# Start the app from Supervisor and set the python3.12 as the default python version to run.
RUN set -x \
  && ln -s /opt/app/system/supervisor.ini /etc/supervisord.d/app.ini \
  && ln -sf /usr/local/bin/python3.12 /usr/bin/python \
  && ln -sf /usr/local/bin/pip3.12 /usr/bin/pip \
  && history -c

# Set default working directory
WORKDIR /opt/app


