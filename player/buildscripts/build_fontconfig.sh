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

LIB_NAME="fontconfig"
VERSION="2.13.1"


create_fontconfig_package_config() {
    cat > "${CROSS_PKG_CONFIG_PATH}/fontconfig.pc" << EOF
prefix=${CROSS_PREBUILT_PREFIX}
exec_prefix=\${prefix}
libdir=\${exec_prefix}/lib
includedir=\${prefix}/include
sysconfdir=\${prefix}/etc
localstatedir=\${prefix}/var
PACKAGE=fontconfig
confdir=\${sysconfdir}/fonts
cachedir=\${localstatedir}/cache/\${PACKAGE}

Name: Fontconfig
Description: Font configuration and customization library
Version: ${VERSION}
Requires:  freetype2 >= 21.0.15, uuid, expat >= 2.2.0, libiconv
Requires.private:
Libs: -L\${libdir} -lfontconfig
Libs.private:
Cflags: -I\${includedir}
EOF
}


# enable common function and enviroment variables
. ${BASEDIR}/buildscripts/enviroment.sh

set_toolchain_paths

clear_lib_path $LIB_NAME

pushd ${BASEDIR}/build/${LIB_NAME}

${BASEDIR}/external/fontconfig-2.13.1/configure \
    --prefix=${CROSS_PREBUILT_PREFIX} \
    --with-pic \
    --without-libintl-prefix \
    --enable-static \
    --disable-shared \
    --disable-fast-install \
    --disable-rpath \
    --disable-libxml2 \
    --disable-docs \
    --host=$(get_target_host) || exit 1

make -j$(get_cpu_count) || exit 1

# CREATE PACKAGE CONFIG MANUALLY
create_fontconfig_package_config

make install || exit 1

popd
