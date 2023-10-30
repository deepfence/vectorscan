FROM alpine:3.18

RUN apk add --no-cache \
    bash \
    boost-dev \
    build-base \
    cmake \
    curl \
    pkgconfig

ENV COLM_VERSION=0.14.7
ENV RAGEL_VERSION=7.0.4
RUN mkdir -p /build && cd build && curl -O https://www.colm.net/files/colm/colm-${COLM_VERSION}.tar.gz && \
    tar -zxvf colm-${COLM_VERSION}.tar.gz && \
    cd /build/colm-${COLM_VERSION} && \
    ./configure --prefix=/opt/colm/colm --disable-manual && make -j$(nproc) && make install && \
    cd /build && \
    curl -O https://www.colm.net/files/ragel/ragel-${RAGEL_VERSION}.tar.gz && \
    tar -zxvf ragel-${RAGEL_VERSION}.tar.gz && \
    cd /build/ragel-${RAGEL_VERSION} && \
    ./configure --prefix=/opt/colm/ragel --with-colm=/opt/colm/colm --disable-manual && make -j$(nproc) && make install

ENV PATH="/opt/colm/ragel/bin/:$PATH"
