# Docker image to use.
FROM sloopstash/base:v1.1.1

# Switch work directory.
WORKDIR /tmp

# Install Oracle JDK.
COPY jdk-8u131-linux-x64.rpm ./
RUN set -x \
  && yum install -y jdk-8u131-linux-x64.rpm \
  && rm jdk-8u131-linux-x64.rpm

# Download, extract, and install Kafka.
RUN set -x \
  && wget https://downloads.apache.org/kafka/3.2.1/kafka_2.13-3.2.1.tgz --quiet \
  && tar xvzf kafka_2.13-3.2.1.tgz > /dev/null \
  && mkdir /usr/local/lib/kafka \
  && cp -r kafka_2.13-3.2.1/* /usr/local/lib/kafka/ \
  && rm -rf kafka_2.13-3.2.1*

# Create Kafka directories.
RUN set -x \
  && mkdir /opt/kafka \
  && mkdir /opt/kafka/data \
  && mkdir /opt/kafka/log \
  && mkdir /opt/kafka/conf \
  && mkdir /opt/kafka/script \
  && mkdir /opt/kafka/system \
  && history -c

# Set default work directory.
WORKDIR /opt/kafka
