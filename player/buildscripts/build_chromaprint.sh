#!/usr/bin/env bash

if [[ -z ${ANDROID_NDK} ]]; then
  echo -e "(*) ANDROID_NDK not defined or is blank\n"
  exit 1
fi

if [[ -z ${ANDROID_SDK} ]]; then
  echo -e "(*) ANSDROID_SDK not defined or is blank\n"
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

create_chromaprint_package_config() {
    local CHROMAPRINT_VERSION="$1"

    cat > "${INSTALL_PKG_CONFIG_DIR}/libchromaprint.pc" << EOF
prefix=${BASEDIR}/prebuilt/android-$(get_target_build)/chromaprint
exec_prefix=\${prefix}
libdir=\${exec_prefix}/lib
includedir=\${prefix}/include

Name: chromaprint
Description: Audio fingerprint library
URL: http://acoustid.org/chromaprint
Version: ${CHROMAPRINT_VERSION}
Libs: -L\${libdir} -lchromaprint
Cflags: -I\${includedir}
EOF
}

# enable common function and enviroment variables
. ${BASEDIR}/buildscripts/enviroment.sh

LIB_NAME="chromaprint"
VERSION="v1.4.3"

set_toolchain_paths

clear_lib_path $LIB_NAME

pushd ${BASEDIR}/external/${LIB_NAME}-${VERSION}

cmake \
  -DCMAKE_TOOLCHAIN_FILE="$ANDROID_NDK/build/cmake/android.toolchain.cmake" \
  -DANDROID_ABI="$(get_android_ndk_cmake_android_abi)" \
  -DANDROID_NATIVE_API_LEVEL="$API" \
  -DCMAKE_INSTALL_PREFIX="${CROSS_PREBUILT_PREFIX}" \
  -DCMAKE_POSITION_INDEPENDENT_CODE=1 \
  -DFFT_LIB=ffmpeg \
  -DBUILD_SHARED_LIBS=0 \
  -DFFMPEG_ROOT="${CROSS_PREBUILT_PREFIX}"

# make -j$(get_cpu_count) || exit 1

# MANUALLY COPY PKG-CONFIG FILES

# make install || exit 1
popd
