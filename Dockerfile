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

# create group and user and install packages
RUN groupadd -r genuser && \
    useradd -g genuser genuser && \
    mkdir /home/genuser && \
    chown -R genuser /home/genuser && \
    apt-get update

RUN apt-get install software-properties-common wget -y

# Install miniconda
ENV CONDA_DIR /opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
     /bin/bash ~/miniconda.sh -b -p /opt/conda && chmod -R a+rwX /opt/conda

# Put conda in path so we can use conda activate
ENV PATH=$CONDA_DIR/bin:$PATH

# swith to user
USER genuser

# Install user level conda packages

RUN conda install -c conda-forge mamba && \
    mamba install -c conda-forge -c bioconda python==3.10 jupyter seaborn plotly matplotlib pandas scikit-learn statsmodels papermill r-base==4.1.2 bioconductor-deseq2=1.34.0 r-tidyverse==1.3.1 r-plotly r-knitr r-stringi r-irkernel

RUN chmod -R a+rwX /home/genuser

WORKDIR /home/genuser

