#####################################################################################################
# Purpose: Building the STAR index is parameterized with a genome size dependent 'genomeSAindexNbases' open
# Upon building the STAR index if 'genomeSAindexNbases' is not ideally parameterized, STAR will suggest a better value
# This image extends the base biocontainer to also include python with is used to dynamically run the index build and use the suggested value if the default
# is not ideally set.
#####################################################################################################

# Start with base multiqc from biocontainers
FROM quay.io/biocontainers/star:2.7.10a--h9ee0642_0

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

RUN apt-get install software-properties-common -y && \
    add-apt-repository ppa:deadsnakes/ppa -y && \
    apt-get install python3.10 -y && \
    # ensure python3.10 is linked to python for shebang support
    ln -s /usr/bin/python3.10 /usr/bin/python

# swith to user
USER genuser

WORKDIR /home/genuser
