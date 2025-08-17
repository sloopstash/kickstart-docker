# Docker image to use.
FROM sloopstash/alma-linux-9:v1.1.1

# Install Python and Pip.
RUN set -x \
  && dnf install -y python3.13 python3.13-devel python3.13-setuptools \
  && dnf install -y python3.13-pip \
  && update-alternatives --install /usr/bin/python python /usr/bin/python3.9 1 \
  && update-alternatives --install /usr/bin/python python /usr/bin/python3.13 2 \
  && update-alternatives --install /usr/bin/pip pip /usr/bin/pip3.13 1 \
  && dnf clean all \
  && rm -rf /var/cache/dnf

# Install Python packages.
WORKDIR /tmp
COPY requirements.txt ./
RUN set -x \
  && pip install -r requirements.txt \
  && rm -f requirements.txt

# Create App directories.
RUN set -x \
  && mkdir /opt/app \
  && mkdir /opt/app/source \
  && mkdir /opt/app/log \
  && mkdir /opt/app/system \
  && touch /opt/app/system/supervisor.ini \
  && ln -s /opt/app/system/supervisor.ini /etc/supervisord.d/app.ini \
  && history -c

# Set default work directory.
WORKDIR /opt/app
