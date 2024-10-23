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

# Create workspace directory and set ownership
RUN mkdir -p /workspace && chown jovyan:users /workspace

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

# Clone the repository into the workspace directory
RUN git clone --single-branch --branch GL4U_Intro_2024 https://github.com/nasa/GeneLab-Training.git /workspace/GeneLab-Training

# Set the default environment to gl4u_intro_2024
RUN echo "conda activate gl4u_intro_2024" >> ~/.bashrc

# Set the working directory to /workspace
WORKDIR /workspace
CMD ["/bin/bash"]