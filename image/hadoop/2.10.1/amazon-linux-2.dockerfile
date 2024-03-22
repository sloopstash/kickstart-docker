# Docker image to use.
FROM sloopstash/base:v1.1.1

# Install Oracle JDK.
WORKDIR /tmp
COPY jdk-8u131-linux-x64.rpm ./
RUN set -x \
  && yum install -y jdk-8u131-linux-x64.rpm \
  && rm -f jdk-8u131-linux-x64.rpm

# Install Hadoop.
RUN set -x \
  && wget https://archive.apache.org/dist/hadoop/common/hadoop-2.10.1/hadoop-2.10.1.tar.gz --quiet \
  && tar xvzf hadoop-2.10.1.tar.gz > /dev/null \
  && mkdir /usr/local/lib/hadoop \
  && cp -r hadoop-2.10.1/* /usr/local/lib/hadoop/ \
  && rm -rf hadoop-2.10.1*

# Create Hadoop directories.
RUN set -x \
  && mkdir /opt/hadoop \
  && mkdir /opt/hadoop/data \
  && mkdir /opt/hadoop/log \
  && mkdir /opt/hadoop/conf \
  && mkdir /opt/hadoop/script \
  && mkdir /opt/hadoop/system \
  && mkdir /opt/hadoop/tmp \
  && touch /opt/hadoop/system/process.pid \
  && history -c

# Set default work directory.
WORKDIR /opt/hadoop
