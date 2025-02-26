# Docker image to use.
FROM sloopstash/base:v1.1.1

# Install system packages.
RUN yum install -y perl-Digest-SHA

# Install Logstash.
WORKDIR /tmp
RUN set -x \
  && wget https://artifacts.elastic.co/downloads/logstash/logstash-8.17.0-linux-x86_64.tar.gz --quiet \
  && wget https://artifacts.elastic.co/downloads/logstash/logstash-8.17.0-linux-x86_64.tar.gz.sha512 --quiet \
  && shasum -a 512 -c logstash-8.17.0-linux-x86_64.tar.gz.sha512 \
  && tar xvzf logstash-8.17.0-linux-x86_64.tar.gz > /dev/null \
  && mkdir /usr/local/lib/logstash \
  && cp -r logstash-8.17.0/* /usr/local/lib/logstash/ \
  && rm -rf logstash-8.17.0*

# Create Logstash directories.
RUN set -x \
  && mkdir /opt/logstash \
  && mkdir /opt/logstash/data \
  && mkdir /opt/logstash/log \
  && mkdir /opt/logstash/conf \
  && mkdir /opt/logstash/script \
  && mkdir /opt/logstash/system \
  && touch /opt/logstash/system/server.pid \
  && touch /opt/logstash/system/supervisor.ini \
  && ln -s /opt/logstash/system/supervisor.ini /etc/supervisord.d/logstash.ini \
  && history -c

# Set default work directory.
WORKDIR /opt/logstash
