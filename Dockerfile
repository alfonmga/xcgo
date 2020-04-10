# This neilotoole/xcgo Dockerfile builds a maximalist Go/Golang CGo-enabled
# cross-compiling image It can build CGo apps on macOS, Linux, and Windows.
# It also contains supporting tools such as docker and snapcraft.
# See https://github.com/neilotoole/xcgo
ARG OSX_SDK="MacOSX10.15.sdk"
ARG OSX_CODENAME="catalina"
ARG OSX_VERSION_MIN="10.10"
ARG OSX_SDK_BASEURL="https://github.com/neilotoole/xcgo/releases/download/v0.1"
ARG OSX_SDK_SUM="d97054a0aaf60cb8e9224ec524315904f0309fbbbac763eb7736bdfbdad6efc8"
ARG OSX_CROSS_COMMIT="bee9df60f169abdbe88d8529dbcc1ec57acf656d"
ARG LIBTOOL_VERSION="2.4.6_1"
ARG LIBTOOL_BASEURL="https://github.com/neilotoole/xcgo/releases/download/v0.1"


FROM ubuntu:19.10 AS golangcore
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    jq \
    lsb-core \
    software-properties-common && rm -rf /var/lib/apt/lists/*

ENV GOPATH="/go"
RUN mkdir -p "${GOPATH}/src"

# As suggested here: https://github.com/golang/go/wiki/Ubuntu
RUN add-apt-repository -y ppa:longsleep/golang-backports
RUN apt-get update && apt-get install -y golang-go && rm -rf /var/lib/apt/lists/*

####################  devtools  ####################
FROM golangcore AS devtools
# Dependencies for https://github.com/tpoechtrager/osxcross and some
# other stuff.

#RUN apt-get update && apt-get install -y --no-install-recommends \
#    build-essential \
#    clang \
#    cmake \
#    mercurial\
#    make \
#    file \
#    gcc-mingw-w64 \
#    llvm-dev\
#    libltdl-dev \
#    wget \
#    unzip\
#    libtool \
#    libxml2-dev \
#    uuid-dev \
#    libssl-dev
#    xz-utils && rm -rf /var/lib/apt/lists/
#
RUN apt-get update && \
    apt-get install -y automake autogen build-essential ca-certificates\
    gcc-9-multilib g++-9-multilib gcc-mingw-w64 g++-mingw-w64 clang \
    libtool libxml2-dev uuid-dev libssl-dev swig pkg-config patch          \
    make xz-utils cpio wget unzip git mercurial bzr help2man --no-install-recommends && rm -rf /var/lib/apt/lists/*

####################  xcgo-final  ####################
FROM devtools AS xcgo-final
ENV PATH=${OSX_CROSS_PATH}/target/bin:$PATH:${GOPATH}/bin
ENV CGO_ENABLED=1

WORKDIR /root
