FROM jupyter/base-notebook

# 10/17/2024
LABEL maintainer="alexis.torres@nasa.gov"
ENV TZ=America/Los_Angeles
# Install OS packages and clean up
USER root
RUN apt-get update \
    && apt-get install -y \
    curl \
    git \
    bsdmainutils \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# Switch to notebook user and continue installs
USER jovyan
COPY --chown=1000:1000 environment.yml /tmp/
RUN mamba env create -f /tmp/environment.yml \
    && rm -rf /tmp/environment.yml \
    && mamba clean -a -y

    # Enable Jupyter extensions 
RUN /bin/bash -c "source activate gl4u_rnaseq_2024 \
    && jupyter contrib nbextension install --user \
    && jupyter nbextensions_configurator enable --user"

# Copy the download_file_urls.py script
COPY --chown=1000:1000 download_file_urls.py /home/jovyan/

# Copy the RNAseq_DGE_JN_anyGLDS_02-2023 1.ipynb notebook
COPY --chown=1000:1000 RNAseq_DGE_JN_anyGLDS.ipynb /home/jovyan/

# Set the default environment to gl4u_rnaseq_2024
RUN echo "conda activate gl4u_rnaseq_2024" >> ~/.bashrc
