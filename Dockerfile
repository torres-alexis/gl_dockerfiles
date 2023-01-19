# The build-stage image:
FROM continuumio/miniconda3 AS build

# Install the package as normal:
COPY environment.yml .
RUN conda env create -f environment.yml

# Install tximport 1.27.1 from github 
# (as per current github head, commit: https://github.com/mikelove/tximport/commit/66bc7bb06fcafad376194ed065b8ce438080e505 on 1/11/2023)
# Remove devtools after as only used to build env
RUN conda run -n this_env Rscript -e "devtools::install_github('mikelove/tximport')" && conda uninstall -n this_env r-devtools

# Install conda-pack:
RUN conda install -c conda-forge conda-pack

# Use conda-pack to create a standalone enviornment
# in /venv:
RUN conda-pack -n this_env -o /tmp/env.tar && \
  mkdir /venv && cd /venv && tar xf /tmp/env.tar && \
  rm /tmp/env.tar

# We've put venv in same path it'll be in final image,
# so now fix up paths:
RUN /venv/bin/conda-unpack


# The runtime-stage image; we can use Debian as the
# base image since the Conda env also includes Python
# for us.
FROM debian:buster AS runtime

# install proc (for ps, needed by Nextflow)
RUN apt-get update && apt-get install procps unzip -y && apt-get clean

# Copy /venv from the previous stage:
COPY --from=build /venv /venv

# When image is run, run the code with the environment
# activated:
COPY entrypoint.sh /.entry/
ENTRYPOINT ["/.entry/entrypoint.sh"]