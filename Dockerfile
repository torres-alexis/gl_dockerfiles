#####################################################################################################
# Purpose: A container of tools used to generate quarto reports 
# - Software
#   - python 3.12
#   - quarto 1.9.36
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

FROM mambaorg/micromamba:2.0-ubuntu22.04

ARG DEBIAN_FRONTEND=noninteractive

# Install system dependencies and Quarto as root
USER root
ENV QUARTO_VERSION=1.9.36
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        wget \
        git \
        software-properties-common \
    && wget "https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.deb" -O /tmp/quarto.deb \
    && dpkg -i /tmp/quarto.deb \
    && rm /tmp/quarto.deb \
    && rm -rf /var/lib/apt/lists/*

# Switch to micromamba user for conda operations
USER $MAMBA_USER
COPY --chown=$MAMBA_USER:$MAMBA_USER ./assets/NF_Affy.yml /tmp/NF_Affy.yml

# Install conda packages into base environment
RUN micromamba install -y -n base -f /tmp/NF_Affy.yml && \
    micromamba clean --all --yes

ENV PATH="/opt/conda/bin:$PATH"

# Rscript installs
RUN Rscript -e "install.packages('stringi', repos='https://cloud.r-project.org')"
RUN Rscript -e "install.packages(c('BiocManager', 'remotes', 'DT'), repos='https://cloud.r-project.org')"
RUN Rscript -e "BiocManager::install('preprocessCore', configure.args = c(preprocessCore = '--disable-threading', force = TRUE))"
RUN Rscript -e "BiocManager::install('oligo', configure.args = c(oligo = '--disable-threading', force = TRUE))"
RUN Rscript -e "BiocManager::install('biomaRt')"
RUN Rscript -e "BiocManager::install('limma')"

RUN rm /tmp/NF_Affy.yml

CMD ["/bin/bash"]