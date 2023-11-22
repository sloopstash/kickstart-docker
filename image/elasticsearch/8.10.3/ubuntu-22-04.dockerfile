# Docker image to use.
FROM sloopstash/base:v1.1.1

# Install system packages.
RUN apt install openjdk-11-jdk

# Download and extract ElasticSearch.
WORKDIR /tmp
RUN set -x \
  && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.10.3-linux-x86_64.tar.gz -O elasticsearch-8.10.3.tar.gz --quiet \
  && tar xvzf elasticsearch-8.10.3.tar.gz > /dev/null 

# Create the softlink.
RUN set -x \
  && rm -rf elasticsearch-8.10.3.tar.gz \
  && mv elasticsearch-8.10.3 elasticsearch  \          
  && ln -s /tmp/elasticsearch /opt/ \
  && history -c

# Set default work directory.
WORKDIR /opt/elasticsearch





