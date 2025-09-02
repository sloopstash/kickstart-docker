# Docker image to use.
FROM sloopstash/amazon-linux-2:v1.1.1

# Install Oracle JDK.
WORKDIR /tmp
COPY jdk-8u131-linux-x64.rpm ./
RUN set -x \
  && yum install -y jdk-8u131-linux-x64.rpm \
  && rm -f jdk-8u131-linux-x64.rpm

# Install Logstash.
RUN set -x \
  && wget https://artifacts.elastic.co/downloads/logstash/logstash-6.8.2.tar.gz --quiet \
  && tar xvzf logstash-6.8.2.tar.gz > /dev/null \
  && mkdir /usr/local/lib/logstash \
  && cp -r logstash-6.8.2/* /usr/local/lib/logstash/ \
  && rm -rf logstash-6.8.2*

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
  && ln -sf /opt/logstash/conf/server.yml /usr/local/lib/logstash/config/logstash.yml \
  && ln -sf /opt/logstash/conf/jvm.options /usr/local/lib/logstash/config/jvm.options \
  && ln -sf /opt/logstash/conf/pipelines.yml /usr/local/lib/logstash/config/pipelines.yml \
  && ln -s /opt/logstash/system/supervisor.ini /etc/supervisord.d/logstash.ini \
  && history -c

# Set default work directory.
WORKDIR /opt/logstash
