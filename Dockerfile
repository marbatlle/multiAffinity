FROM continuumio/miniconda3 as build_env
COPY . /tmp
WORKDIR /tmp
RUN env \
    && conda env create --name multiaffinity --file environment.yaml \
    && conda info \
    && conda clean --all --yes --force-pkgs-dirs 
RUN conda update -n base conda
RUN conda install -c anaconda libcurl

FROM ubuntu
COPY --from=build_env /opt/conda/envs/multiaffinity /opt/conda/envs/multiaffinity
ENV PATH=/opt/conda/envs/multiaffinity/bin/:$PATH

SHELL ["/bin/bash", "-c"]

ADD tool ./tool
ENV HOME /tool
WORKDIR ${HOME}
RUN mkdir -p output

# Install MolTI-DREAM
ADD tool/bin/Communities/src/MolTi-DREAM ./bin/Communities/src/MolTi-DREAM

RUN apt-get update && apt-get install -y \
    build-essential \   
    && apt-get clean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists*
RUN make -C bin/Communities/src/MolTi-DREAM/src

# The code to run when container is started:
ENV PATH="$PATH:."
ENV PATH="$PATH:/tool/."
ENV PATH="$PATH:/tool/bin/."
RUN chmod +x multiaffinity
CMD ["/bin/bash"]