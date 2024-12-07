# Docker image to use.
FROM sloopstash/base:v1.1.1

# Install Oracle JDK.
WORKDIR /tmp
COPY jdk-8u131-linux-x64.rpm ./
RUN set -x \
  && yum install -y jdk-8u131-linux-x64.rpm \
  && rm -f jdk-8u131-linux-x64.rpm

# Install Spark.
RUN set -x \
  && wget https://dlcdn.apache.org/spark/spark-3.5.3/spark-3.5.3-bin-hadoop3.tgz --quiet \
  && tar xvzf spark-3.5.3-bin-hadoop3.tgz > /dev/null \
  && mkdir /usr/local/lib/spark \
  && cp -r spark-3.5.3-bin-hadoop3/* /usr/local/lib/spark/ \
  && rm -rf spark-3.5.3-bin-hadoop3*

# Create Spark directories.
RUN set -x \
  && mkdir /opt/spark \
  && mkdir /opt/spark/data \
  && mkdir /opt/spark/log \
  && mkdir /opt/spark/conf \
  && mkdir /opt/spark/script \
  && mkdir /opt/spark/system \
  && touch /opt/spark/system/node.pid \
  && touch /opt/spark/system/supervisor.ini \
  && ln -s /opt/spark/system/supervisor.ini /etc/supervisord.d/spark.ini \
  && history -c

# Set default work directory.
WORKDIR /opt/spark
