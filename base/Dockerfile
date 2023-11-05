FROM ubuntu:jammy

# Install packages that we want to make available at both build and run time
RUN apt update && \
  apt install -y xz-utils ca-certificates libyaml-0-2 && \
  rm -rf /var/lib/apt/lists/*

# Set required CNB target information
ARG distro_name
LABEL io.buildpacks.base.distro.name=${distro_name}
ARG distro_version
LABEL io.buildpacks.base.distro.version=${distro_version}
