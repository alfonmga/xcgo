FROM golang:latest
RUN apt-get update && apt-get install -y \
    gcc-multilib gcc-mingw-w64 g++-mingw-w64 g++-multilib \
      xz-utils unzip --no-install-recommends && rm -rf /var/lib/apt/lists/*

ENV CGO_ENABLED=1

WORKDIR /root