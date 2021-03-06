FROM ubuntu:bionic

LABEL maintainer="haliterdogan@gmail.com"

# Install tooling
RUN apt-get update && \
  apt-get install -y \
    ca-certificates \
    software-properties-common

# Use bash as /bin/sh
RUN ln -sf /bin/bash /bin/sh

# Install Steam
RUN echo steam steam/question select "I AGREE" | debconf-set-selections && \
  echo steam steam/license note '' | debconf-set-selections

RUN add-apt-repository multiverse && \
  dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get install -y lib32gcc1 lib32stdc++6 steamcmd

# Add a steam user
RUN useradd -m steam

# Rest should be executed as the steam user
USER steam

# Install CS:GO
COPY update_csgo.sh /usr/local/bin/
RUN update_csgo.sh

# Add the entrypoint
COPY entrypoint.sh /

ENTRYPOINT /entrypoint.sh

# Copy templates
ADD files /home/steam/files
