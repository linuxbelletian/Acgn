#!/usr/bin/env bash

if [[ -z ${ANDROID_NDK} ]]; then
  echo -e "(*) ANDROID_NDK not defined or is blank\n"
  exit 1
fi

if [[ -z ${ARCH} ]]; then
  echo -e "(*) ARCH not defined or is blank\n"
  exit 1
fi

if [[ -z ${API} ]]; then
  echo -e "(*) API not defined or is blank\n"
  exit 1
fi

if [[ -z ${BASEDIR} ]]; then
  echo -e "(*) BASEDIR not defined or is blank\n"
  exit 1
fi

# enable common function and enviroment variables
. ${BASEDIR}/buildscripts/enviroment.sh

LIB_NAME="libass"

set_toolchain_paths

clear_lib_path $LIB_NAME

CPU_SPECIFIC_OPTIONS=""

case ${ARCH} in
    x64)
        CPU_SPECIFIC_OPTIONS="--enable-hardware-optimizations --enable-intel-sse=yes"
    ;;
    arm64)
        CPU_SPECIFIC_OPTIONS="--enable-hardware-optimizations --enable-arm-neon=yes"
    ;;
esac

pushd ${BASEDIR}/build/${LIB_NAME}

#echo "$(pkg-config --cflags fontconfig)"
#echo "$(pkg-config --libs --static fontconfig)"
#echo "$(pkg-config --libs --static libiconv)"
#echo "$(pkg-config --cflags libiconv)"


${BASEDIR}/external/libass-0.14.0/configure \
    --prefix=${CROSS_PREBUILT_PREFIX} \
    --with-pic \
    --enable-static \
    --disable-coretext \
    --disable-profile \
    --disable-libtool-lock \
    --disable-harfbuzz \
    --disable-shared \
    --disable-fast-install \
    --host=$(get_target_host) || exit 1

make -j$(get_cpu_count) || exit 1

make install || exit 1

# MANUALLY COPY PKG-CONFIG FILES
cp ./*.pc ${CROSS_PKG_CONFIG_PATH} || exit 1

popd
