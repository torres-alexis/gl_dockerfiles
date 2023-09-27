# Starting image we will build on top of.  Can be found on dockerhub: https://hub.docker.com/_/ubuntu/tags
FROM ubuntu:23.10
# FROM continuumio/miniconda # Decent starting image for anaconda based installations

# Installs wget as an example tool installation.
RUN apt-get update && \
    apt-get install wget -y

# It is recommended to copy installation files into the container and install from there.
#   This is ideal compared to downloading from the internet as it is more reproducible.
COPY assets/reference_file.txt /opt/reference_file.txt

