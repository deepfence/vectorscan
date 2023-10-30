#!/bin/bash
set -eux

rm -rf ./build || true
mkdir -p build
(
    cd build
    cmake ..
    make -j$(nproc)
    make install
)

tar -cjf vectorscan-$(uname -m).tar.bz2 \
    /usr/local/lib/pkgconfig/libhs.pc \
    /usr/local/include/hs/hs.h \
    /usr/local/include/hs/hs_common.h \
    /usr/local/include/hs/hs_compile.h \
    /usr/local/include/hs/hs_runtime.h \
    /usr/local/lib/libhs_runtime.a \
    /usr/local/lib/libhs.a
