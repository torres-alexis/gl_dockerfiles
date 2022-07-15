# Start with base multiqc from biocontainers
FROM quay.io/biocontainers/multiqc:1.12--pyhdfd78af_0

# Add zip to image
# Zip is needed to zip multiqc reports

# Ensure no user interaction is requested
ARG DEBIAN_FRONTEND=noninteractive

# create group and user and install packages
RUN groupadd -r genuser && \
    useradd -g genuser genuser && \
    mkdir /home/genuser && \
    chmod -R 777 /home/genuser && \
    apt-get update

# Add zip to image
# Zip is needed to zip multiqc reports
RUN apt-get update
RUN apt-get install zip -y

# swith to user
USER genuser

WORKDIR /home/genuser
