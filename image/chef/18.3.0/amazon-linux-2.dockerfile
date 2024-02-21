# Docker image to use.
FROM sloopstash/base:v1.1.1

# Install OpenSSH server.
RUN set -x \
  && yum install -y openssh-server openssh-clients passwd

# Configure OpenSSH server.
RUN set -x \
  && mkdir /var/run/sshd \
  && ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' \
  && sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# Configure OpenSSH user.
RUN set -x \
  && mkdir /root/.ssh \
  && touch /root/.ssh/authorized_keys \
  && touch /root/.ssh/config \
  && echo -e "Host *\n\tStrictHostKeyChecking no\n\tUserKnownHostsFile=/dev/null" >> /root/.ssh/config \
  && chmod 400 /root/.ssh/config
ADD node.pub /root/.ssh/authorized_keys

# Switch work directory.
WORKDIR /tmp

# Install Chef infra client.
COPY chef-18.3.0-1.el7.x86_64.rpm ./
RUN set -x \
  && mkdir /var/log/chef \
  && yum install -y chef-18.3.0-1.el7.x86_64.rpm \
  && rm chef-18.3.0-1.el7.x86_64.rpm \
  && history -c

# Set default work directory.
WORKDIR /
