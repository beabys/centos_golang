ARG CENTOS_VERSION=7
ARG GOLANG_VERSION=1.16.5
FROM centos:$CENTOS_VERSION as centos_base

FROM centos_base AS base-386-1.16.5
ARG GOLANG_VERSION=$GOLANG_VERSION
ENV GOLANG_DOWNLOAD_URL=https://golang.org/dl/go$GOLANG_VERSION.linux-386.tar.gz
ENV GOLANG_DOWNLOAD_SHA256=a37c6b71d0b673fe8dfeb2a8b3de78824f05d680ad32b7ac6b58c573fa6695de
FROM centos_base AS base-386-1.15.13
ARG GOLANG_VERSION=$GOLANG_VERSION
ENV GOLANG_DOWNLOAD_URL=https://golang.org/dl/go$GOLANG_VERSION.linux-386.tar.gz
ENV GOLANG_DOWNLOAD_SHA256=8df80ccbbd57b108ec43066925bf02aac47bc9e0236894dbd019f26944d27399

FROM centos_base AS base-amd64-1.16.5
ARG GOLANG_VERSION=$GOLANG_VERSION
ARG GOLANG_DOWNLOAD_URL=https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz
ARG GOLANG_DOWNLOAD_SHA256=b12c23023b68de22f74c0524f10b753e7b08b1504cb7e417eccebdd3fae49061
FROM centos_base AS base-amd64-1.15.13
ARG GOLANG_VERSION=$GOLANG_VERSION
ARG GOLANG_DOWNLOAD_URL=https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256=3d3beec5fc66659018e09f40abb7274b10794229ba7c1e8bdb7d8ca77b656a13

FROM centos_base AS base-arm64-1.16.5
ARG GOLANG_VERSION=$GOLANG_VERSION
ENV GOLANG_DOWNLOAD_URL=https://golang.org/dl/go$GOLANG_VERSION.linux-arm64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256=d5446b46ef6f36fdffa852f73dfbbe78c1ddf010b99fa4964944b9ae8b4d6799
FROM centos_base AS base-arm64-1.15.13
ARG GOLANG_VERSION=$GOLANG_VERSION
ENV GOLANG_DOWNLOAD_URL=https://golang.org/dl/go$GOLANG_VERSION.linux-arm64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256=f3989dca4dea5fbadfec253d7c24e4111773b203e677abb1f01e768a99cc14e6

# FROM centos_base AS base-armv7

# ARG GOLANG_VERSION=$GOLANG_VERSION
# ENV GOLANG_DOWNLOAD_URL=https://golang.org/dl/go$GOLANG_VERSION.linux-armv6l.tar.gz
# ENV GOLANG_DOWNLOAD_SHA256=00ff453f102c67ff6b790ba0cb10cecf73c8e8bbd9d913e5978ac8cc6323132f

#install dependencies
FROM base-$TARGETARCH-$GOLANG_VERSION
RUN yum install -y epel-release && yum update -y
RUN yum install -y tar openssl-devel make gcc gcc-c++ patch zlib zlib-devel  \
  cmake libxml2-devel libxslt-devel curl rpm-build bzip2 autoconf automake libtool wget \
  nano curl-devel expat-devel gettext-devel perl-ExtUtils-MakeMaker

## install Git
RUN yum -y remove git
RUN cd /usr/src && \
  wget https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.32.0.tar.gz && \
  tar xzf git-2.32.0.tar.gz && \
  cd git-2.32.0 && \
  make prefix=/usr/local/git all && \
  make prefix=/usr/local/git install && \
  echo "export PATH=$PATH:/usr/local/git/bin" >> /root/.bashrc && \
  source /root/.bashrc


# install go
RUN curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
  && echo "$GOLANG_DOWNLOAD_SHA256 golang.tar.gz" | sha256sum -c - \
  && tar -C /usr/local -xzf golang.tar.gz \
  && rm golang.tar.gz

ENV PATH /go/bin:/usr/local/go/bin:$PATH

# prepare go-env
RUN mkdir -p "/go/src" "/go/bin" "/go/pkg" && chmod -R 777 "/go"
ENV CGO_ENABLED=0