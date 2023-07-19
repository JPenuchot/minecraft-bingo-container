FROM archlinux:latest

USER root

# Creating papermc user

RUN useradd -md /srv/papermc papermc

# Arch packages install

RUN pacman -Syu --noconfirm
RUN pacman -S --noconfirm \
  curl \
  git \
  jdk-openjdk \
  jq

# Minecraft server setup

USER root
USER papermc
WORKDIR /srv/papermc

ADD --chown=papermc:papermc \
  latest-paper.sh \
  ops.json \
  whitelist.json \
  /srv/papermc/

RUN ./latest-paper.sh

# Fetchr setup

RUN mkdir -p /srv/papermc/Fetchr-5.1-beta5/datapacks

RUN curl https://github.com/NeunEinser/bingo/releases/download/5.1-beta5/Fetchr-5.1-beta5-datapack.zip \
  -Lo Fetchr-5.1-beta5/datapacks/Fetchr.zip

RUN curl https://github.com/NeunEinser/bingo/releases/download/5.1-beta5/server.properties \
  -Lo server.properties

RUN echo eula=true >> eula.txt

RUN echo '' >> server.properties
RUN echo 'server-port=25566' >> server.properties
RUN echo 'whitelist=true' >> server.properties
RUN echo 'enforce-secure-profile=false' >> server.properties

RUN chmod -w server.properties

# Running papermc

ADD --chown=papermc:papermc entrypoint.sh .
CMD ./entrypoint.sh
