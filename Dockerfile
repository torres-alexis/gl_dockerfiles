# The build-stage image:
    FROM continuumio/miniconda3 AS build

    # Install conda packages
    COPY ./assets/gl_DESeq2.yml /tmp/
    RUN conda install -c conda-forge mamba \
        && mamba env update -n base -f /tmp/gl_DESeq2.yml \
        && Rscript -e "install.packages(c('BiocManager', 'remotes'), repos='https://cloud.r-project.org')" \
        && Rscript -e "install.packages('knitr', repos='https://cloud.r-project.org')" \
        && Rscript -e "install.packages('tidyverse', repos='https://cloud.r-project.org')" \
        && Rscript -e "install.packages('optparse', repos='https://cloud.r-project.org')" \
        && Rscript -e "install.packages('here', repos='https://cloud.r-project.org')" \
        && Rscript -e "install.packages('cli', repos='https://cloud.r-project.org')" \
        && Rscript -e "install.packages('tibble', repos='https://cloud.r-project.org')" \
        && Rscript -e "install.packages('dt', repos='https://cloud.r-project.org')" \
        && Rscript -e "BiocManager::install('DESeq2')" \
        && Rscript -e "BiocManager::install('tximport')" \
        && rm /tmp/gl_DESeq2.yml
    
    ARG DEBIAN_FRONTEND=noninteractive
    RUN apt-get update && apt-get install unzip -y
    
    # When image is run, run the code with the environment
    # activated:
    COPY entrypoint.sh /.entry/
    RUN chmod a+rx /.entry/entrypoint.sh
    ENTRYPOINT ["/.entry/entrypoint.sh"]