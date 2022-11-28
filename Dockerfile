#####################################################################################################
# Purpose: Multiqc is often used in conjunction with zip to compress the multiqc report
# The base biocontainer for multiqc does not include zip, thus this image extends by installing zip
#####################################################################################################

# Start with base multiqc from biocontainers
FROM quay.io/biocontainers/trim-galore:0.6.7--hdfd78af_0

# Add zip to image
# Zip is needed to zip multiqc reports

# Ensure no user interaction is requested
ARG DEBIAN_FRONTEND=noninteractive

# upgrade cutadapt to version 3.7
RUN  pip install cutadapt==3.7
