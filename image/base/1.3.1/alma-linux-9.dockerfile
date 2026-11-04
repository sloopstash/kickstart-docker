#Docker image to use
FROM almalinux:9

# Install system packages and Supervisor.
RUN set -x \
  && dnf update -y \
  && dnf install -y epel-release \
  && dnf install -y \
    ca-certificates \
    openssl \
    wget \
    vim \
    net-tools \
    gcc \
    gcc-c++ \
    make \
    cmake \
    tar \
    git \
    unzip \
    sysstat \
    tree \
    initscripts \
    bind-utils \
    nmap \
    logrotate \
    crontabs \
    python3 \
    supervisor \
    dnf-plugins-core \
  && dnf config-manager --add-repo \
    https://developer.download.nvidia.com/compute/cuda/repos/rhel9/x86_64/cuda-rhel9.repo \
  && dnf clean all \
  && rm -rf /var/cache/dnf 
 
# Set default work directory.
WORKDIR /