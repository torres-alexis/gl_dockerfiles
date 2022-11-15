FROM ubuntu:bionic-20220902

# Ensure no user interaction is requested
ARG DEBIAN_FRONTEND=noninteractive

# create group and user and install packages
RUN groupadd -r genuser && \
    useradd -g genuser genuser && \
    mkdir /home/genuser && \
    chown -R genuser /home/genuser && \
    apt-get update && \
    apt-get install --no-install-recommends software-properties-common wget git dssp -y && \
    rm -rf /var/lib/apt/lists/*

# Install miniconda
ENV CONDA_DIR /opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
     /bin/bash ~/miniconda.sh -b -p /opt/conda && chmod -R a+rwX /opt/conda

# Install source code
# link python to correct path
RUN git clone https://github.com/clauswilke/proteinER.git /proteinER && \
    chmod a+x /proteinER/src/* && \
    ln -s /opt/conda/bin/python /usr/bin/python

ENV PATH=/proteinER/src:$PATH

# Put conda in path so we can use conda activate
ENV PATH=$CONDA_DIR/bin:$PATH

# swith to user
USER genuser

# Install user level conda packages

RUN conda install -c conda-forge -c bioconda numpy biopython

RUN chmod -R a+rwX /home/genuser

WORKDIR /home/genuser
