#####################################################################################################
# Purpose: A container of tools used to generate quarto reports 
# - Software
#   - python 3.11
#   - quarto 1.4.551
#   - python libraries
#     - matplotlib
#     - plotly
#     - seaborn
#     - scikit-learn
#   - R
#     - knitr
#     - tidyverse
#     - plotly
# Known Issues:
#   - Cannot use R rendering at this time due to this bug
# processing file: test_r.qmd
# Error in dyn.load(file, DLLpath = DLLpath, ...) : 
#   unable to load shared object '/opt/conda/lib/R/library/stringi/libs/stringi.so':
#   libicui18n.so.58: cannot open shared object file: No such file or directory
# Calls: .main ... namespaceImport -> loadNamespace -> library.dynam -> dyn.load
# Execution halted
#####################################################################################################

FROM ubuntu:jammy

# Ensure no user interaction is requested
ARG DEBIAN_FRONTEND=noninteractive

# Install conda
ENV CONDA_DIR /opt/conda
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        wget \
        git \
        software-properties-common \
    && wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh \
    && /bin/bash ~/miniconda.sh -b -p $CONDA_DIR && chmod -R a+rwX $CONDA_DIR \
    && rm -rf /var/lib/apt/lists/*

# Put conda in path
ENV PATH=$CONDA_DIR/bin:$PATH

# Install Quarto
ENV QUARTO_VERSION 1.4.551
RUN wget "https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.deb" -O /tmp/quarto.deb \
    && dpkg -i /tmp/quarto.deb \
    && rm /tmp/quarto.deb

# Set locale for R
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

# Install conda packages
COPY ./assets/NF_Affy.yml /tmp/
RUN conda install -c conda-forge mamba \
    && mamba env update -n base -f /tmp/NF_Affy.yml \
    # This fixes the issue: 'libicui18n.so.58: cannot open shared object file: No such file or directory'
    && Rscript -e "install.packages('stringi', repos='https://cloud.r-project.org')" \ 
    # This fixes Error in `rma.background.correct()`: \ ! ERROR; return code from pthread_create() is 22
    && BiocManager::install("oligo", configure.args="--disable-threading", force = TRUE) \
    && rm /tmp/NF_Affy.yml

# Create group and user
RUN groupadd -r genuser \
    && useradd -g genuser genuser \
    && mkdir /home/genuser \
    && chown -R genuser /home/genuser \
    && chmod -R a+rwX /home/genuser

# Set user to genuser
USER genuser
WORKDIR /home/genuser