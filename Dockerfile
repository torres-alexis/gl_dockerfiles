FROM python:3.8-slim-bullseye

RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

RUN pip install numpy==1.19.1 pandas==1.1.0 scipy==1.5.2 matplotlib==3.2.2 \
    seaborn==0.10.1 jinja2==3.0.0a1 lxml==4.5.2 pyteomics==4.3.2 \
    comtypes==1.1.7 dask[complete]==2.22.0 distributed==2.4.0

RUN wget https://bitbucket.org/incpm/prot-qc/get/9de1e5a057b4.zip && \
    unzip 9de1e5a057b4.zip && \
    cd /incpm-prot-qc-9de1e5a057b4 && \
    python setup.py install