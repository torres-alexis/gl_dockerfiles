# Start with base multiqc from biocontainers
FROM ubuntu:bionic-20220902

# Add zip to image
# Zip is needed to zip multiqc reports

# Ensure no user interaction is requested
ARG DEBIAN_FRONTEND=noninteractive

# Copy and install quarto
COPY ./babel /babel

# create group and user and install packages
RUN groupadd -r genuser && \
    useradd -g genuser genuser && \
    mkdir /home/genuser && \
    chown -R genuser /home/genuser && \
    apt-get update && \
    apt-get install --no-install-recommends software-properties-common wget git -y

# Install miniconda
ENV CONDA_DIR /opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
     /bin/bash ~/miniconda.sh -b -p /opt/conda && chmod -R a+rwX /opt/conda

# Put conda in path so we can use conda activate
ENV PATH=$CONDA_DIR/bin:$PATH

# swith to user
USER genuser

# Install user level conda packages

# RUN conda install anaconda-client -n base; anaconda login;  conda env update -n /babel/environment.yml
RUN conda env update --file /babel/environment.yml
    
RUN chmod -R a+rwX /home/genuser

WORKDIR /home/genuser