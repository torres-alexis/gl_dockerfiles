# Use R 4.4.0 as the base image
FROM rocker/r-ver:4.4.0

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libfontconfig1-dev \
    libfreetype6-dev \
    libfribidi-dev \
    libglpk-dev \
    make \
    libharfbuzz-dev \
    libcurl4-openssl-dev \
    libicu-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libxml2-dev \
    libssl-dev \
    pandoc \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libpcre2-dev \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install tidyverse
RUN R -e "install.packages('tidyverse', repos='https://cloud.r-project.org')"

# Install BiocManager and set Bioconductor version to 3.19
RUN R -e "install.packages('BiocManager', repos='https://cloud.r-project.org')" \
    && R -e "BiocManager::install(version = '3.19')"

# Install specified Bioconductor packages (excluding org.*.db packages)
RUN R -e "BiocManager::install(c( \
    'STRINGdb', \
    'PANTHER.db', \
    'rtracklayer', \
    'AnnotationForge', \
    'biomaRt', \
    'GO.db' \
))"

# Create and set working directory
RUN mkdir -p /home/user
WORKDIR /home/user
