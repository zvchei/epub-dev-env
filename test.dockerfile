FROM ubuntu:22.04

ARG USER
ARG REPOSITORY

ENV DEBCONF_NOWARNINGS=yes
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install unzip default-jre inotify-tools

RUN useradd -m ${USER}
USER ${USER}

COPY --chown=${USER} scripts/test.sh /home/${USER}/

WORKDIR /home/${USER}
COPY tools/epubcheck-5.1.0.zip .
RUN unzip -q epubcheck-5.1.0.zip

RUN mkdir /home/${USER}/${REPOSITORY}
# Directories for additional repositories must be created here, otherwise they
# won't be writable from within the container.

ENV USER=${USER}
ENV REPOSITORY=${REPOSITORY}
ENTRYPOINT ["bash", "test.sh"]
