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
    ./configure --prefix=/opt/colm/ragel --with-colm=/opt/colm/colm --disable-manual && make -j$(nproc) && make install && \
    rm -rf /build

ENV PATH="/opt/colm/ragel/bin/:$PATH"

COPY . /src/

RUN bash <<EOF
set -eux

(
    cd /src
    mkdir -p build
    cd build
    cmake ..
    make -j$(nproc) hs
    make install
)
rm -rf /src

tar -cjf /vectorscan.tar.bz2 \
    /usr/local/lib/pkgconfig/libhs.pc \
    /usr/local/include/hs/hs.h \
    /usr/local/include/hs/hs_common.h \
    /usr/local/include/hs/hs_compile.h \
    /usr/local/include/hs/hs_runtime.h \
    /usr/local/lib/libhs_runtime.a \
    /usr/local/lib/libhs.a

EOF
