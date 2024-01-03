FROM ubuntu:22.04

ARG USER
ARG REPOSITORY

ENV DEBCONF_NOWARNINGS=yes
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install git inotify-tools

RUN useradd -m ${USER}
USER ${USER}

# The development container sets up Git, though without any credentials.
COPY --chown=${USER} scripts/git-setup.sh /home/${USER}/
ARG GIT_AUTHOR_NAME
ARG GIT_AUTHOR_EMAIL
ENV GIT_AUTHOR_NAME=${GIT_AUTHOR_NAME}
ENV GIT_AUTHOR_EMAIL=${GIT_AUTHOR_EMAIL}
RUN bash /home/${USER}/git-setup.sh

COPY --chown=${USER} scripts/build.sh /home/${USER}/

RUN mkdir /home/${USER}/${REPOSITORY}
# Directories for additional repositories must be created here, otherwise they
# won't be writable from within the container.

ENV USER=${USER}
ENV REPOSITORY=${REPOSITORY}
WORKDIR /home/${USER}
ENTRYPOINT ["bash", "build.sh"]
