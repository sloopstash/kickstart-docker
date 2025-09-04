# Docker image to use.
FROM sloopstash/amazon-linux-2:v1.1.1

# Install APM.
WORKDIR /tmp
RUN set -x \
  && wget https://artifacts.elastic.co/downloads/apm-server/apm-server-6.8.2-linux-x86_64.tar.gz --quiet \
  && sha1sum apm-server-6.8.2-linux-x86_64.tar.gz \
  && tar xvzf apm-server-6.8.2-linux-x86_64.tar.gz > /dev/null \
  && mkdir /usr/local/lib/apm \
  && cp -r apm-server-6.8.2-linux-x86_64/* /usr/local/lib/apm/ \
  && rm -rf apm-server-6.8.2*

# Create APM directories.
RUN set -x \
  && mkdir /opt/apm \
  && mkdir /opt/apm/data \
  && mkdir /opt/apm/log \
  && mkdir /opt/apm/conf \
  && mkdir /opt/apm/script \
  && mkdir /opt/apm/system \
  && touch /opt/apm/system/server.pid \
  && touch /opt/apm/system/supervisor.ini \
  && ln -sf /opt/apm/conf/server.yml /usr/local/lib/apm/apm-server.yml \
  && ln -s /opt/apm/system/supervisor.ini /etc/supervisord.d/apm.ini \
  && history -c

# Set default work directory.
WORKDIR /opt/apm
