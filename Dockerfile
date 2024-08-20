#####################################################################################################
# Purpose: A container of tools used to generate quarto reports 
# - Software
#   - python 3.10
#   - quarto 1.1.189
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

# Copy and install quarto
COPY ./assets/quarto-1.2.313-linux-amd64.deb /tmp/assets/

# create group and user and install packages
RUN groupadd -r genuser && \
    useradd -g genuser genuser && \
    mkdir /home/genuser && \
    chown -R genuser /home/genuser /tmp/assets && \
    apt-get update && \
    apt-get install --no-install-recommends software-properties-common wget git -y && \
    dpkg -i /tmp/assets/quarto-1.2.313-linux-amd64.deb && \
    rm  /tmp/assets/quarto-1.2.313-linux-amd64.deb && \
    rm -rf /var/lib/apt/lists/*

# Install miniconda
ENV CONDA_DIR /opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
     /bin/bash ~/miniconda.sh -b -p /opt/conda && chmod -R a+rwX /opt/conda

# Put conda in path so we can use conda activate
ENV PATH=$CONDA_DIR/bin:$PATH

# Switch to user
USER genuser

COPY ./assets/primeview_annotation.R /tmp/assets/
COPY ./assets/NF_Affy.yml /tmp/assets/
COPY ./assets/PrimeView.na36.annot.csv /tmp/assets/

# Install user level conda packages, PrimeView annotation package
RUN conda install -c conda-forge mamba && \
    mamba env update -n base -f /tmp/assets/NF_Affy.yml && \
    # Fixes the issue: 'libicui18n.so.58: cannot open shared object file: No such file or directory'
    Rscript -e "install.packages('stringi', repos='https://cloud.r-project.org')" && \
    Rscript -e "install.packages("pd.primeview/", repos = NULL, type = "source")", 
    rm -r /tmp/assets/NF_Affy.yml


# Set permissions
RUN chmod -R a+rwX /home/genuser

# Set working directory
WORKDIR /home/genuser
