FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    wget \
    procps \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV CONDA_DIR=/opt/conda
ARG TARGETARCH
RUN case "${TARGETARCH}" in \
      amd64) MF_ARCH=x86_64 ;; \
      arm64) MF_ARCH=aarch64 ;; \
      *) echo "unsupported arch: ${TARGETARCH}" >&2; exit 1 ;; \
    esac \
    && wget --quiet "https://github.com/conda-forge/miniforge/releases/download/24.11.2-1/Miniforge3-24.11.2-1-Linux-${MF_ARCH}.sh" -O /tmp/miniforge.sh \
    && /bin/bash /tmp/miniforge.sh -b -p ${CONDA_DIR} \
    && rm /tmp/miniforge.sh \
    && chmod -R a+rwX ${CONDA_DIR}

ENV PATH=${CONDA_DIR}/bin:${PATH}

COPY ./assets/env.yml /tmp/env.yml

RUN mamba env update -n base -f /tmp/env.yml \
    && rm /tmp/env.yml \
    && mamba clean -afy \
    && chmod -R a+rwX ${CONDA_DIR}

WORKDIR /opt
