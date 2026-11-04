#Docker image to use
FROM --platform=linux/amd64 sloopstash/alma-linux-9-llama-cpp:v1.0.0 AS build_llama_cpp_amd64

ARG LLAMA_REF=master

#Nvidia GPU architectures
#86 - RTX 30-series, 89 - RTX 40-series
ARG CUDA_ARCHITECTURES="86;89" 

########### BUILD STAGE##########
# Install CUDA development packages, repo configured in base image 1.0.0
RUN set -x \
    && dnf install -y \
        cuda-toolkit-12-9 \
        cuda-libraries-12-9 \
    && dnf clean all \
    && rm -rf /var/cache/dnf 

ENV CUDA_HOME=/usr/local/cuda-12.9
ENV PATH=${CUDA_HOME}/bin:${PATH}
ENV CUDACXX=${CUDA_HOME}/bin/nvcc

# Download llama.cpp from source
WORKDIR /tmp

RUN set -x \
    && git clone \
    --depth 1 \
    --branch "${LLAMA_REF}" \
    https://github.com/ggml-org/llama.cpp.git \
    /tmp/llama.cpp 

# Configure and build llama.cpp with CUDA support
WORKDIR /tmp/llama.cpp

#GGML_CUDA=ON:  Builds the CUDA backend
#GGML_NATIVE=OFF:  Prevents optimization for only CPU build
RUN set -x \
    && command -v nvcc \
    && nvcc --version \
    && cmake -S . -B build \
        -DCMAKE_BUILD_TYPE=Release \
        -DGGML_NATIVE=OFF \
        -DGGML_CUDA=ON \
        -DCMAKE_CUDA_COMPILER="${CUDACXX}" \
        -DCMAKE_CUDA_ARCHITECTURES="${CUDA_ARCHITECTURES}" \
        -DCUDAToolkit_ROOT="${CUDA_HOME}" \
    && cmake --build build \
        --config Release \
        --parallel 4 \
    && mkdir -p \
        /opt/llama-cpp/bin \
        /opt/llama-cpp/lib \
    && cmake --install build \
        --prefix /opt/llama-cpp \
    && cp -a build/bin/. \
        /opt/llama-cpp/bin/ \
    && find build \
        \( -type f -o -type l \) \
        -name 'lib*.so*' \
        -exec cp -a '{}' /opt/llama-cpp/lib/ \; \
    && test -d /opt/llama-cpp/lib \
    && ls -la /opt/llama-cpp/lib 


########### RUNTIME STAGE ##########

FROM --platform=linux/amd64 sloopstash/alma-linux-9-llama-cpp:v1.0.0

#Install runtime dependencies
RUN set -x \
    && dnf install -y cuda-libraries-12-9 \
    && dnf clean all \
    && rm -rf /var/cache/dnf 

# Create workload directory
RUN set -x \
    && mkdir -p \
       /opt/llama-cpp \
       /opt/llama-cpp/model \
       /opt/llama-cpp/data \
       /opt/llama-cpp/log \
       /opt/llama-cpp/conf \
       /opt/llama-cpp/script \
       /opt/llama-cpp/system \
    && touch /opt/llama-cpp/system/server.pid 

# Copy llama.cpp binaries from build stage
COPY --from=build_llama_cpp_amd64 \
    /opt/llama-cpp/bin/ \
    /opt/llama-cpp/bin/

COPY --from=build_llama_cpp_amd64 \
    /opt/llama-cpp/lib/ \
    /opt/llama-cpp/lib/

# Copy supervisor configuration
COPY workload/llama-cpp/0.3.0/conf/supervisor.ini \
    /opt/llama-cpp/system/supervisor.ini

RUN set -x \
    && ln -s \
       /opt/llama-cpp/system/supervisor.ini \
       /etc/supervisord.d/llama-cpp.ini \
    && find /opt/llama-cpp/bin \
       -type f \
       -exec chmod +x '{}' \;


#Lib and binary path environment variables
ENV PATH=/opt/llama-cpp/bin:${PATH}
ENV LD_LIBRARY_PATH=/opt/llama-cpp/lib:/usr/local/cuda/lib64

# Model directory & path environment variables
ENV LLAMA_MODELS=/opt/llama-cpp/model 
ENV LLAMA_MODEL=/opt/llama-cpp/model/model.gguf

# 999 means offload as many layers as possible to the GPU.
# Set to 0 to run using the CPU backend.
ENV LLAMA_N_GPU_LAYERS=999

# Server network settings.
ENV LLAMA_HOST=0.0.0.0
ENV LLAMA_PORT=8000

# CUDA container runtime settings.
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility

WORKDIR /opt/llama-cpp

EXPOSE 8000

ENTRYPOINT []
CMD ["/usr/bin/python3", "-m", "supervisor.supervisord", "-n", "-c", "/etc/supervisord.conf"]