FROM public.ecr.aws/smce/smce-images:smce-oss-earth-base-f3f0ad36

# 10/17/2024
LABEL maintainer="alexis.torres@nasa.gov"

# Install OS packages and clean up
USER root
RUN apt-get update \
    && apt-get install -y \
    curl \
    git \
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
RUN /bin/bash -c "source activate gl4u_intro_2024 \
    && jupyter contrib nbextension install --user \
    && jupyter nbextensions_configurator enable --user"