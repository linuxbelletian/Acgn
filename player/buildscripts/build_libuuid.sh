#!/usr/bin/env bash


LIB_NAME="libuuid"

LIB_VERSION="1.0.3"

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

# Since fontconfig using uuid header file as uuid/uuid.h
# but origin uuid.pc's include is "Cflags: -I${includedir}/uuid"
# so we should create a custom uuid.pc modify this line
create_uuid_package_config() {
    cat > "${CROSS_PKG_CONFIG_PATH}/uuid.pc" << EOF
prefix=${CROSS_PREBUILT_PREFIX}
exec_prefix=\${prefix}
libdir=\${exec_prefix}/lib
includedir=\${prefix}/include

Name: uuid
Description: Universally unique id library
Version: ${VERSION}
Requires:
Cflags: -I\${includedir}
Libs: -L\${libdir} -luuid
EOF
}

# enable common function and enviroment variables
. ${BASEDIR}/buildscripts/enviroment.sh

set_toolchain_paths

clear_lib_path $LIB_NAME

pushd ${BASEDIR}/build/${LIB_NAME}

${BASEDIR}/external/libuuid-${LIB_VERSION}/configure \
    --prefix=${CROSS_PREBUILT_PREFIX} \
    --with-pic \
    --enable-static \
    --disable-shared \
    --disable-fast-install \
    --host=$(get_target_host) || exit 1

make -j$(get_cpu_count) || exit 1

# MANUALLY COPY PKG-CONFIG FILES
create_uuid_package_config

make install || exit 1
popd
