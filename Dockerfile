FROM continuumio/miniconda3 as build_env
COPY . /tmp
WORKDIR /tmp
RUN env \
    && conda env create --name multiAffinity --file environment.yaml \
    && conda info \
    && conda clean --all --yes --force-pkgs-dirs 
RUN conda update -n base conda
RUN conda install -c anaconda libcurl

FROM ubuntu
COPY --from=build_env /opt/conda/envs/multiAffinity /opt/conda/envs/multiAffinity
ENV PATH=/opt/conda/envs/multiAffinity/bin/:$PATH

SHELL ["/bin/bash", "-c"]

ADD tool ./tool
WORKDIR /tool

# Install MolTI-DREAM
ADD tool/bin/Communities/src/MolTi-DREAM-master ./bin/Communities/src/MolTi-DREAM-master

RUN apt-get update && apt-get install -y \
    build-essential \   
    && apt-get clean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists*
RUN make -C bin/Communities/src/MolTi-DREAM-master/src

# Inputs
VOLUME /input

# The code to run when container is started:
RUN chmod +x multiAffinity
CMD ["/bin/bash", "-c"]