FROM centos:7

ENV GOLANG_VERSION 1.16.5

ENV GOLANG_DOWNLOAD_URL https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256 b12c23023b68de22f74c0524f10b753e7b08b1504cb7e417eccebdd3fae49061

#install dependencies
RUN yum install -y epel-release
RUN yum install -y tar git openssl-devel make gcc gcc-c++ patch zlib zlib-devel  \
  cmake libxml2-devel libxslt-devel curl rpm-build bzip2 autoconf automake libtool wget

# install go
RUN curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
  && echo "$GOLANG_DOWNLOAD_SHA256  golang.tar.gz" | sha256sum -c - \
  && tar -C /usr/local -xzf golang.tar.gz \
  && rm golang.tar.gz

ENV PATH /go/bin:/usr/local/go/bin:$PATH

# prepare go-env
RUN mkdir -p "/go/src" "/go/bin" "/go/pkg" && chmod -R 777 "/go"
ENV CGO_ENABLED=0