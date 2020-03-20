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

LIB_NAME="freetype"
VERSION="2.10.1"

create_freetype_package_config() {

  cat > "${CROSS_PKG_CONFIG_PATH}/freetype2.pc" << EOF
prefix=${CROSS_PREBUILT_PREFIX}
exec_prefix=\${prefix}
libdir=\${exec_prefix}/lib
includedir=\${prefix}/include

Name: FreeType 2
URL: https://freetype.org
Description: A free, high-quality, and portable font engine.
Version: 23.1.17
Requires:
Requires.private: zlib, libpng
Libs: -L\${libdir} -lfreetype -lpng16
Libs.private:
Cflags: -I\${includedir}/freetype2
EOF
}

set_toolchain_paths

clear_lib_path $LIB_NAME

pushd ${BASEDIR}/build/${LIB_NAME}

# set android-zlib pkgconfig.pc file
create_zlib_package_config

# OVERRIDING PKG-CONFIG

${BASEDIR}/external/freetype-${VERSION}/configure \
   --prefix=${CROSS_PREBUILT_PREFIX} \
   --with-pic \
   --with-zlib \
   --with-png \
   --without-harfbuzz \
   --without-bzip2 \
   --without-fsref \
   --without-quickdraw-toolbox \
   --without-quickdraw-carbon \
   --without-ats \
   --enable-static \
   --disable-shared \
   --disable-fast-install \
   --disable-mmap \
   --host=$(get_target_host) || exit 1

make -j$(get_cpu_count) || exit 1

# MANUALLY COPY PKG-CONFIG FILES
create_freetype_package_config

make install || exit 1
popd
