# FragPipeAnalystR
# v.1.1.1
# Base image: rocker/r-base:4.5.2
# Multi-platform: linux/amd64, linux/arm64

FROM rocker/r-base:4.5.2

# Set environment variables
ENV R_BASE_VERSION=4.5.2
ENV LANG=en_US.UTF-8

# Install system dependencies for R packages
RUN apt-get update && \
    apt-get -y install libcurl4-openssl-dev libxml2-dev libnetcdf-dev libfontconfig1-dev libcairo2-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install renv package manager and remotes
RUN Rscript -e 'install.packages(c("renv", "remotes"))'

# Install FragPipeAnalystR from GitHub (version 1.1.1)
RUN Rscript -e 'remotes::install_github("Nesvilab/FragPipeAnalystR", ref = "v1.1.1", upgrade = "never")'

# Install optparse
RUN Rscript -e 'install.packages(c("optparse"), repos = "https://cloud.r-project.org")'


# Default command
CMD ["R"]
