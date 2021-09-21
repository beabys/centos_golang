ARG CENTOS_VERSION=7
ARG GOLANG_VERSION=1.17.1
FROM beabys/centos${CENTOS_VERSION}_git as beabys_centos_base

FROM beabys_centos_base AS base-amd64-1.17.1
ARG GOLANG_VERSION=$GOLANG_VERSION
ARG GOLANG_DOWNLOAD_URL=https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz
ARG GOLANG_DOWNLOAD_SHA256=dab7d9c34361dc21ec237d584590d72500652e7c909bf082758fb63064fca0ef
FROM beabys_centos_base AS base-amd64-1.16.7
ARG GOLANG_VERSION=$GOLANG_VERSION
ARG GOLANG_DOWNLOAD_URL=https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz
ARG GOLANG_DOWNLOAD_SHA256=7fe7a73f55ba3e2285da36f8b085e5c0159e9564ef5f63ee0ed6b818ade8ef04
FROM beabys_centos_base AS base-amd64-1.16.6
ARG GOLANG_VERSION=$GOLANG_VERSION
ARG GOLANG_DOWNLOAD_URL=https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz
ARG GOLANG_DOWNLOAD_SHA256=be333ef18b3016e9d7cb7b1ff1fdb0cac800ca0be4cf2290fe613b3d069dfe0d
FROM beabys_centos_base AS base-amd64-1.15.13
ARG GOLANG_VERSION=$GOLANG_VERSION
ARG GOLANG_DOWNLOAD_URL=https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256=3d3beec5fc66659018e09f40abb7274b10794229ba7c1e8bdb7d8ca77b656a13

FROM beabys_centos_base AS base-arm64-1.17.1
ARG GOLANG_VERSION=$GOLANG_VERSION
ENV GOLANG_DOWNLOAD_URL=https://golang.org/dl/go$GOLANG_VERSION.linux-arm64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256=53b29236fa03ed862670a5e5e2ab2439a2dc288fe61544aa392062104ac0128c
FROM beabys_centos_base AS base-arm64-1.16.7
ARG GOLANG_VERSION=$GOLANG_VERSION
ENV GOLANG_DOWNLOAD_URL=https://golang.org/dl/go$GOLANG_VERSION.linux-arm64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256=63d6b53ecbd2b05c1f0e9903c92042663f2f68afdbb67f4d0d12700156869bac
FROM beabys_centos_base AS base-arm64-1.16.6
ARG GOLANG_VERSION=$GOLANG_VERSION
ENV GOLANG_DOWNLOAD_URL=https://golang.org/dl/go$GOLANG_VERSION.linux-arm64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256=9e38047463da6daecab9017cd0599f33f84991e68263752cfab49253bbc98c30
FROM beabys_centos_base AS base-arm64-1.15.13
ARG GOLANG_VERSION=$GOLANG_VERSION
ENV GOLANG_DOWNLOAD_URL=https://golang.org/dl/go$GOLANG_VERSION.linux-arm64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256=f3989dca4dea5fbadfec253d7c24e4111773b203e677abb1f01e768a99cc14e6


#install dependencies
FROM base-$TARGETARCH-$GOLANG_VERSION
RUN yum update -y

# install go
RUN curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
  && echo "$GOLANG_DOWNLOAD_SHA256 golang.tar.gz" | sha256sum -c - \
  && tar -C /usr/local -xzf golang.tar.gz \
  && rm golang.tar.gz

ENV PATH /go/bin:/usr/local/go/bin:$PATH

RUN echo "export PATH=$PATH" >> /root/.bashrc && \
  source /root/.bashrc

# prepare go-env
RUN mkdir -p "/go/src" "/go/bin" "/go/pkg" && chmod -R 777 "/go"
ENV CGO_ENABLED=0