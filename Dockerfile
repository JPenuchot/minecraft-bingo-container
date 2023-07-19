FROM archlinux:latest

USER root

# Arch packages

RUN pacman -Syu --noconfirm
RUN pacman -S --noconfirm \
  base-devel \
  curl \
  git \
  jdk-openjdk \
  jq

# AUR package builder user

RUN useradd -m builder
RUN usermod -aG wheel builder
RUN echo '%wheel ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers

# Paru install

USER builder
RUN git clone https://aur.archlinux.org/paru-bin.git /tmp/paru
WORKDIR /tmp/paru
RUN makepkg -si --noconfirm

# AUR packages
USER builder
RUN paru -S --noconfirm latestpaper-bin

# Minecraft server setup

USER root
RUN useradd -md /srv/papermc papermc
USER papermc
WORKDIR /srv/papermc

# Initial setup

ADD --chown=papermc:papermc \
  entrypoint.sh \
  latest-paper.sh \
  ops.json \
  whitelist.json \
  /srv/papermc/

RUN ./latest-paper.sh

# Fetchr setup

RUN mkdir -p /srv/papermc/Fetchr-5.1-beta5/datapacks

RUN curl https://github.com/NeunEinser/bingo/releases/download/5.1-beta5/Fetchr-5.1-beta5-datapack.zip \
  -Lo /srv/papermc/Fetchr-5.1-beta5/datapacks/Fetchr.zip

RUN curl https://github.com/NeunEinser/bingo/releases/download/5.1-beta5/server.properties \
  -Lo server.properties

RUN echo eula=true >> eula.txt

RUN echo 'whitelist=true' >> server.properties
RUN echo 'server-port=25566' >> server.properties
RUN echo 'enforce-secure-profile=false' >> server.properties

# Running papermc

CMD /srv/papermc/entrypoint.sh
