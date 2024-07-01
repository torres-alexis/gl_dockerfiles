FROM r-base:4.4.0

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    pandoc \
    && rm -rf /var/lib/apt/lists/* \
    && Rscript -e "install.packages(c('BiocManager', 'remotes'), repos='https://cloud.r-project.org')" \
    && Rscript -e "install.packages('knitr', repos='https://cloud.r-project.org')" \
    && Rscript -e "install.packages('tidyverse', repos='https://cloud.r-project.org')" \
    && Rscript -e "install.packages('optparse', repos='https://cloud.r-project.org')" \
    && Rscript -e "install.packages('here', repos='https://cloud.r-project.org')" \
    && Rscript -e "install.packages('cli', repos='https://cloud.r-project.org')" \
    && Rscript -e "install.packages('tibble', repos='https://cloud.r-project.org')" \
    && Rscript -e "install.packages('DT', repos='https://cloud.r-project.org')" \
    && Rscript -e "BiocManager::install('DESeq2')" \
    && Rscript -e "BiocManager::install('tximport')"
COPY ./assets/install_pandoc.sh /tmp/
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      wget \
      graphviz \
      texlive-latex-extra \
      lmodern \
      perl && \
      /tmp/install_pandoc.sh && \
      install2.r rmarkdown \
    && rm /tmp/install_pandoc.sh
