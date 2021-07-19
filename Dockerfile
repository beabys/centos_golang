ARG CENTOS_VERSION=7
ARG GOLANG_VERSION=1.16.6
FROM centos:$CENTOS_VERSION as centos_base


FROM centos_base AS base-amd64-1.16.6
ARG GOLANG_VERSION=$GOLANG_VERSION
ARG GOLANG_DOWNLOAD_URL=https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz
ARG GOLANG_DOWNLOAD_SHA256=be333ef18b3016e9d7cb7b1ff1fdb0cac800ca0be4cf2290fe613b3d069dfe0d
FROM centos_base AS base-amd64-1.15.13
ARG GOLANG_VERSION=$GOLANG_VERSION
ARG GOLANG_DOWNLOAD_URL=https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256=3d3beec5fc66659018e09f40abb7274b10794229ba7c1e8bdb7d8ca77b656a13

FROM centos_base AS base-arm64-1.16.6
ARG GOLANG_VERSION=$GOLANG_VERSION
ENV GOLANG_DOWNLOAD_URL=https://golang.org/dl/go$GOLANG_VERSION.linux-arm64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256=9e38047463da6daecab9017cd0599f33f84991e68263752cfab49253bbc98c30
FROM centos_base AS base-arm64-1.15.13
ARG GOLANG_VERSION=$GOLANG_VERSION
ENV GOLANG_DOWNLOAD_URL=https://golang.org/dl/go$GOLANG_VERSION.linux-arm64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256=f3989dca4dea5fbadfec253d7c24e4111773b203e677abb1f01e768a99cc14e6


#install dependencies
FROM base-$TARGETARCH-$GOLANG_VERSION
RUN yum install -y epel-release && yum update -y
RUN yum install -y tar openssl-devel make gcc gcc-c++ patch zlib zlib-devel  \
  cmake libxml2-devel libxslt-devel curl rpm-build bzip2 autoconf automake libtool wget \
  nano curl-devel expat-devel gettext-devel perl-ExtUtils-MakeMaker openssl-client

## install Git
RUN yum -y remove git
RUN cd /usr/src && \
  wget https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.32.0.tar.gz && \
  tar xzf git-2.32.0.tar.gz && \
  cd git-2.32.0 && \
  make prefix=/usr/local/git all && \
  make prefix=/usr/local/git install

# install go
RUN curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
  && echo "$GOLANG_DOWNLOAD_SHA256 golang.tar.gz" | sha256sum -c - \
  && tar -C /usr/local -xzf golang.tar.gz \
  && rm golang.tar.gz

ENV PATH /usr/local/git/bin:/go/bin:/usr/local/go/bin:$PATH

RUN echo "export PATH=$PATH" >> /root/.bashrc && \
  source /root/.bashrc

# prepare go-env
RUN mkdir -p "/go/src" "/go/bin" "/go/pkg" && chmod -R 777 "/go"
ENV CGO_ENABLED=0