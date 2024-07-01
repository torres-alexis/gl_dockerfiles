FROM r-base:4.4.0

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    pandoc \
    && rm -rf /var/lib/apt/lists/*

COPY ./assets/install_pandoc.sh /tmp/

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      wget \
      graphviz \
      texlive-latex-extra \
      lmodern \
      procps \
      perl && \
      /tmp/install_pandoc.sh && \
      install2.r rmarkdown \
      BiocManager \
      knitr \
      tidyverse \
      optparse \
      here \
      cli \
      tibble \
      DT \
    && rm /tmp/install_pandoc.sh

RUN R -e "BiocManager::install(c('DESeq2', 'tximport'))"
