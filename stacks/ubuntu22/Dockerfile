#
# Base
#
FROM ubuntu:jammy as base

# buildpack-related image config
LABEL io.buildpacks.stack.id="com.lytol.plow.ubuntu22"
LABEL io.buildpacks.stack.maintainer="Brian Smith <brian.e.smith@gmail.com>"
LABEL io.buildpacks.stack.homepage=""
LABEL io.buildpacks.stack.distro.name="Ubuntu"
LABEL io.buildpacks.stack.distro.version="22.04"
LABEL io.buildpacks.stack.description="Ubuntu 22.04 stack for plow"
LABEL io.buildpacks.stack.released="2023-02-07"

# install packages
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential \
    ca-certificates \
    wget \
    curl \
    g++ \
    gcc \
    gfortran \
    libbz2-dev \
    libc6 \
    libcairo2 \
    libcurl4 \
    libglib2.0-0 \
    libgomp1 \
    libicu-dev \
    libjpeg8 \
    liblzma-dev \
    libopenblas-dev \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libpaper-utils \
    libpcre2-dev \
    libpng16-16 \
    libreadline8 \
    libtcl8.6 \
    libtiff5 \
    libtk8.6 \
    libx11-6 \
    libxt6 \
    make \
    ucf \
    unzip \
    zip \
    zlib1g-dev \
  && rm -rf /var/lib/apt/lists/*

#
# Build
#
FROM base as build

ENV CNB_STACK_ID="com.lytol.plow.ubuntu22"
ENV CNB_USER_ID=1000
ENV CNB_GROUP_ID=1000

RUN groupadd builduser --gid ${CNB_GROUP_ID} && \
  useradd --uid ${CNB_USER_ID} --gid ${CNB_GROUP_ID} -m -s /bin/bash builduser

USER ${CNB_USER_ID}:${CNB_GROUP_ID}

#
# Run
#
FROM base as run

RUN groupadd runuser && \
  useradd -g runuser -m -s /bin/bash runuser

USER runuser:runuser
