#####################################################################################################
# Purpose: A container of tools used to generate quarto reports 
# - Software
#   - python 3.10
#   - quarto 1.6.40
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

# Start with base multiqc from biocontainers
FROM ubuntu:bionic-20220902

# Add zip to image
# Zip is needed to zip multiqc reports

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

# Install Quarto
ENV QUARTO_VERSION 1.6.40
RUN wget "https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.deb" -O /tmp/quarto.deb \
    && dpkg -i /tmp/quarto.deb \
    && rm /tmp/quarto.deb

# Put conda in path so we can use conda activate
ENV PATH=$CONDA_DIR/bin:$PATH

# Create user
RUN groupadd -r genuser && \
    useradd -r -g genuser genuser && \
    mkdir /home/genuser && \
    chown -R genuser:genuser /home/genuser

# Install mamba
RUN conda install -c conda-forge mamba
ENV MAMBA_ROOT_PREFIX=/opt/conda

# Update environment with yml file
COPY ./assets/NF_Affy.yml /tmp/assets/
RUN mamba env update -n base -f /tmp/assets/NF_Affy.yml

# Install CRAN packages
RUN Rscript -e 'install.packages(c("stringi", "DT", "stringr"), repos="https://cloud.r-project.org")'

# Install preprocessCore and disable threading
RUN Rscript -e 'BiocManager::install("preprocessCore", configure.args="--disable-threading", force = TRUE)'

# Cleanup
RUN rm -r /tmp/assets

RUN chmod -R a+rwX /home/genuser

# Switch to user
USER genuser
WORKDIR /home/genuser