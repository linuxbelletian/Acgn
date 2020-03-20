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

LIB_NAME="fribidi"
VERSION="1.0.9"

set_toolchain_paths

clear_lib_path $LIB_NAME

pushd ${BASEDIR}/build/${LIB_NAME}

${BASEDIR}/external/fribidi-${VERSION}/configure \
    --prefix=${CROSS_PREBUILT_PREFIX} \
    --with-pic \
    --enable-static \
    --disable-shared \
    --disable-fast-install \
    --disable-debug \
    --disable-deprecated \
    --host=$(get_target_host) || exit 1

make -j$(get_cpu_count) || exit 1

# MANUALLY COPY PKG-CONFIG FILES
cp ./*.pc ${CROSS_PKG_CONFIG_PATH} || exit 1

make install || exit 1

echo "------- Build fribidi Finished!!"
popd
