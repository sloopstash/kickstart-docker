# Docker image to use.
FROM sloopstash/base:v1.1.1

# Install JDK 17
WORKDIR /tmp
RUN set -x \
  && wget https://download.oracle.com/java/17/archive/jdk-17.0.12_linux-x64_bin.tar.gz --quiet \
  && tar xvzf jdk-17.0.12_linux-x64_bin.tar.gz > /dev/null \
  && mv jdk-17.0.12 /usr/local/bin/ \
  && rm -f jdk-17_linux-x64_bin.rpm


# Envirnoment path Logstash Java path and Logstash Path
ENV LS_JAVA_HOME=/usr/local/bin/jdk-17.0.12
ENV PATH=$PATH:/usr/local/bin/logstash-8.16.0/bin

# Install Logstash V18.6
RUN set -x \
  && wget https://artifacts.elastic.co/downloads/logstash/logstash-8.16.0-linux-x86_64.tar.gz --quiet \
  && tar xvzf logstash-8.16.0-linux-x86_64.tar.gz > /dev/null \
  && mv logstash-8.16.0 /usr/local/bin/ \
  && rm logstash-8.16.0-linux-x86_64.tar.gz

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

# Set the working directory for Logstash
WORKDIR /opt/logstash