# Apache spark using python.
# Docker image to use.
FROM sloopstash/base:v1.1.1

# Set working directory and copy files.
WORKDIR /tmp

# Download Python.
ADD https://www.python.org/ftp/python/3.11.5/Python-3.11.5.tgz /tmp/

# Install required tools and extract Python.
RUN set -x \
   && yum clean all \
   && yum update -y \
   && yum install -y tar \
   && tar -xvf Python-3.11.5.tgz    

# Download and Extract Apache Spark.
RUN set -x \
    && wget https://archive.apache.org/dist/spark/spark-3.4.3/spark-3.4.3-bin-hadoop3.tgz --quiet \
    && tar -xvzf spark-3.4.3-bin-hadoop3.tgz > /dev/null \
    && mkdir -p /usr/local/lib/spark \
    && cp -r spark-3.4.3-bin-hadoop3/* /usr/local/lib/spark/ \
    && rm -rf spark-3.4.3-bin-hadoop3*

# Create ApacheSpark directories.
RUN set -x \
  && mkdir /opt/apachespark \
  && mkdir /opt/apachespark/data \
  && mkdir /opt/apachespark/log \
  && mkdir /opt/apachespark/conf \
  && mkdir /opt/apachespark/script \
  && mkdir /opt/apachespark/system \
  && touch /opt/apachespark/system/server.pid \
  && touch /opt/apachespark/conf/supervisor.ini \
  && ln -s /opt/apachespark/conf/supervisor.ini /etc/supervisord.d/apachespark.ini \
  && history -c

# Set default work directory
WORKDIR /opt/apachespark
