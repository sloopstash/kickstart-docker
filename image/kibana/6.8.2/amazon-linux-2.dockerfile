# Docker image to use.
FROM sloopstash/amazon-linux-2:v1.1.1

# Install Kibana.
WORKDIR /tmp
RUN set -x \
  && wget https://artifacts.elastic.co/downloads/kibana/kibana-6.8.2-linux-x86_64.tar.gz --quiet \
  && sha1sum kibana-6.8.2-linux-x86_64.tar.gz \
  && tar xvzf kibana-6.8.2-linux-x86_64.tar.gz > /dev/null \
  && mkdir /usr/local/lib/kibana \
  && cp -r kibana-6.8.2-linux-x86_64/* /usr/local/lib/kibana/ \
  && rm -rf kibana-6.8.2*

# Create Kibana directories.
RUN set -x \
  && mkdir /opt/kibana \
  && mkdir /opt/kibana/data \
  && mkdir /opt/kibana/log \
  && mkdir /opt/kibana/conf \
  && mkdir /opt/kibana/script \
  && mkdir /opt/kibana/system \
  && touch /opt/kibana/system/server.pid \
  && touch /opt/kibana/system/supervisor.ini \
  && ln -s /opt/kibana/system/supervisor.ini /etc/supervisord.d/kibana.ini \
  && history -c

# Set default work directory.
WORKDIR /opt/kibana
