FROM continuumio/miniconda3

LABEL maintainer="Mar Batlle"

WORKDIR /

COPY environment.yml .

RUN conda env create -f environment.yml

# Make RUN commands use the new environment:
RUN echo "conda activate multiAffinity" >> ~/.bashrc
SHELL ["/bin/bash", "--login", "-c"]
RUN conda update -n base conda
RUN conda install -c anaconda libcurl

ADD tool ./tool
WORKDIR /tool

# Install MolTI-DREAM
ADD tool/bin/Communities/src/MolTi-DREAM-master ./bin/Communities/src/MolTi-DREAM-master
RUN apt-get update && apt-get install -y \
    build-essential*
RUN make -C bin/Communities/src/MolTi-DREAM-master/src

# The code to run when container is started:
CMD echo 'The following environment running:' $CONDA_DEFAULT_ENV