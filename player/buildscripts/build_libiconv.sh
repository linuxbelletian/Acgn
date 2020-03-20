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

LIB_NAME="libiconv"
VERSION="1.16"

create_libiconv_package_config() {
    cat > "${CROSS_PKG_CONFIG_PATH}/libiconv.pc" << EOF
prefix=${CROSS_PREBUILT_PREFIX}
exec_prefix=\${prefix}
libdir=\${exec_prefix}/lib
includedir=\${prefix}/include

Name: libiconv
Description: Character set conversion library
Version: ${VERSION}

Requires:
Libs: -L\${libdir} -liconv -lcharset
Cflags: -I\${includedir}
EOF
}

# enable common function and enviroment variables
. ${BASEDIR}/buildscripts/enviroment.sh

set_toolchain_paths

clear_lib_path $LIB_NAME

pushd ${BASEDIR}/build/${LIB_NAME}

${BASEDIR}/external/libiconv-${VERSION}/configure \
    --prefix=${CROSS_PREBUILT_PREFIX} \
    --with-pic \
    --enable-static \
    --disable-shared \
    --disable-fast-install \
    --disable-rpath \
    --host=$(get_target_host) || exit 1

make -j$(get_cpu_count) || exit 1

# MANUALLY COPY PKG-CONFIG FILES
create_libiconv_package_config

make install || exit 1
echo "------- Build iconv Finished!!"
popd
