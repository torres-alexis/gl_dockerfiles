# Use the official Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Set non-interactive mode for apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Install essential system packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    wget \
    perl \
    procps \
    pandoc \
    texlive-latex-extra \
    lmodern \
    graphviz \
    libssl-dev \
    libfontconfig1-dev \
    libxml2-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Miniconda
ENV CONDA_DIR /opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
     /bin/bash ~/miniconda.sh -b -p /opt/conda && \
     chmod -R a+rwX /opt/conda

# Add Conda to PATH
ENV PATH=$CONDA_DIR/bin:$PATH

# Copy the updated env.yml into the Docker image
COPY ./assets/env.yml /tmp/assets/

# Install Mamba for faster package management and update the Conda environment
RUN conda install -c conda-forge mamba && \
    mamba env update -n base -f /tmp/assets/env.yml && \
    rm -r /tmp/assets

# Install R packages using BiocManager within the Conda environment
RUN R -e 'options(repos = c(CRAN = "https://cloud.r-project.org/")); \
          install.packages(c("rmarkdown", \
                            "knitr", \
                            "tidyverse", \
                            "optparse", \
                            "here", \
                            "cli", \
                            "tibble", \
                            "DT", \
                            "BiocManager"), \
                            dependencies=TRUE)' && \
    R -e 'options(repos = c(CRAN = "https://cloud.r-project.org/")); \
          BiocManager::install(c("DESeq2", "tximport"), update=FALSE, ask=FALSE)'

# Install Python packages
RUN pip install --no-cache-dir \
    jupyterlab \
    notebook \
    pandas \
    seaborn \
    matplotlib \
    numpy \
    scipy