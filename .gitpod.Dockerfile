FROM nfcore/gitpod

# Install custom tools, runtime, etc.
RUN sudo apt-get update && sudo apt-get install -y \
    build-essential \
    uuid-dev \
    libgpgme-dev \
    squashfs-tools \
    libseccomp-dev \
    wget \
    pkg-config \
    git \
    cryptsetup-bin && sudo rm -rf /var/lib/apt/lists/*


# Install Go
RUN wget https://go.dev/dl/go1.20.linux-amd64.tar.gz && \
    sudo tar -C /usr/local -xzf go1.20.linux-amd64.tar.gz && \
    export PATH=$PATH:/usr/local/go/bin && \
    go version

# Install Singularity
RUN export PATH=$PATH:/usr/local/go/bin && \
    wget https://github.com/sylabs/singularity/releases/download/v3.9.8/singularity-ce-3.9.8.tar.gz && \
    tar -xzf singularity-ce-3.9.8.tar.gz && \
    cd singularity-ce-3.9.8 && \
    ./mconfig --without-suid && \
    make -C ./builddir && \
    sudo make -C ./builddir install
    
# Clean up and refine config
RUN cd && rm -rf singularity-ce-3.9.* && \
    sudo cat /usr/local/etc/singularity/singularity.conf | sed 's;mount proc = no;mount proc = yes;g' > /usr/local/etc/singularity/singularity.conf && \
    echo "bind path = /proc" >> /usr/local/etc/singularity/singularity.conf

RUN echo ". /usr/local/etc/bash_completion.d/singularity" >> ${HOME}/.bashrc
