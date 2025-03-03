FROM ubuntu:jammy

ENV DEBIAN_FRONTEND=noninteractive

# We need source repos for build-dep
RUN sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list

# Install packages that we want to make available at both build and run time
RUN apt-get update && \
  apt-get install -y \
    xz-utils \
    ca-certificates \
    libyaml-0-2 \
    libcurl4-openssl-dev \
    curl \
    wget \
    jq \
  && apt build-dep r-base -y \
  && rm -rf /var/lib/apt/lists/*

# Set required CNB target information
ARG distro_name
LABEL io.buildpacks.base.distro.name=${distro_name}
ARG distro_version
LABEL io.buildpacks.base.distro.version=${distro_version}
