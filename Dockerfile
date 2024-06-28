# The build-stage image:
    FROM continuumio/miniconda3 AS build

    # Install conda packages
    COPY ./assets/gl_DESeq2.yml /tmp/
    RUN conda install -c conda-forge mamba \
        && mamba env update -n base -f /tmp/gl_DESeq2.yml \
        && Rscript -e "install.packages(c('BiocManager', 'remotes'), repos='https://cloud.r-project.org')" \
        && rm /tmp/gl_DESeq2.yml
    
    ARG DEBIAN_FRONTEND=noninteractive
    RUN apt-get update && apt-get install unzip -y
    
    # When image is run, run the code with the environment
    # activated:
    COPY entrypoint.sh /.entry/
    RUN chmod a+rx /.entry/entrypoint.sh
    ENTRYPOINT ["/.entry/entrypoint.sh"]