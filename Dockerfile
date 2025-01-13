FROM r-base:4.4.2

# Install system dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    pandoc \
    wget \
    graphviz \
    texlive-latex-extra \
    lmodern \
    procps \
    perl \
    python3 \
    python3-pip \
    python3-pandas \
    python3-seaborn \
    python3-matplotlib \
    python3-notebook \
    python3-numpy \
    python3-scipy \
    # Dependencies for tidyverse based on errors
    libfontconfig1-dev \
    libxml2-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    && rm -rf /var/lib/apt/lists/*

COPY ./assets/install_pandoc.sh /tmp/

RUN /tmp/install_pandoc.sh && \
    rm /tmp/install_pandoc.sh

# Install R packages 
RUN R -e 'install.packages(c("rmarkdown", \
                            "knitr", \
                            "tidyverse", \
                            "optparse", \
                            "here", \
                            "cli", \
                            "tibble", \
                            "DT", \
                            "BiocManager"), \
                            repos="https://cloud.r-project.org/")' && \
    R -e 'BiocManager::install(c("DESeq2", "tximport"))'