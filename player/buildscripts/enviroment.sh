#!/usr/bin/env bash


get_cpu_count() {
  if [[ "$(uname)" == "Darwin" ]]; then
    echo $(sysctl -n hw.physicalcpu)
  else
    echo $(nproc)
  fi
}

# We only support build on macOS
get_ndk_host_tag() {
  if [[ "$(uname)" == "Darwin" ]]; then
    echo "darwin-x86_64"
  else
    echo "Unknown"
  fi
}

# must set ARCH variable
# arm64|x64
get_ndk_triple() {
  case ${ARCH} in
    arm64)
      echo "aarch64-linux-android"
    ;;
    x64)
      echo "x86_64-linux-android"
    ;;
  esac
}

get_host_os() {
  case $(uname -s) in
    Darwin)
      echo "darwin"
      ;;
    Linux)
      echo "linux"
      ;;
  esac
}

get_target_host() {
  get_ndk_triple
}


clear_lib_path() {
  local libname=$1
  rm -rf ${BASEDIR}/build/${libname}
  mkdir ${BASEDIR}/build/${libname}
}

get_android_platform_arch_name() {
  case ${ARCH} in
    arm64)
      echo arch-arm64
      ;;
    x64)
      echo arch-x86_64
      ;;
  esac
}

get_android_ndk_cmake_android_abi() {
  case ${ARCH} in
    arm64)
      echo arm64-v8a
    ;;
    x64)
      echo x86_64
    ;;
  esac
}

# for freetype2 in pkg-config search
create_zlib_package_config() {
    ZLIB_VERSION=$(grep '#define ZLIB_VERSION' ${ANDROID_NDK}/toolchains/llvm/prebuilt/$(get_ndk_host_tag)/sysroot/usr/include/zlib.h | grep -Eo '\".*\"' | sed -e 's/\"//g')

    cat > "${CROSS_PKG_CONFIG_PATH}/zlib.pc" << EOF
prefix=${ANDROID_NDK}/toolchains/llvm/prebuilt/$(get_android_ndk_cmake_android_abi)/sysroot/usr
exec_prefix=\${prefix}
libdir=${ANDROID_NDK}/platforms/android-${API}/$(get_android_platform_arch_name)/usr/lib
includedir=\${prefix}/include

Name: zlib
Description: zlib compression library
Version: ${ZLIB_VERSION}

Requires:
Libs: -L\${libdir} -lz
Cflags: -I\${includedir}
EOF
}

# set the toolchain clang/clang++ and binutils
set_toolchain_paths() {
  export LOCAL_TOOLCHAIN_PREFIX="${ANDROID_NDK}/toolchains/llvm/prebuilt/$(get_ndk_host_tag)/bin/$(get_ndk_triple)"
  export CC="${LOCAL_TOOLCHAIN_PREFIX}${API}-clang"
  export CXX="${LOCAL_TOOLCHAIN_PREFIX}${API}-clang++"
  export CPP="$CC -E"
  export AR="${LOCAL_TOOLCHAIN_PREFIX}-ar"
  export AS="${LOCAL_TOOLCHAIN_PREFIX}-as"
  export ADDR2LINE="${LOCAL_TOOLCHAIN_PREFIX}-addr2line"
  export DWP="${LOCAL_TOOLCHAIN_PREFIX}-dwp"
  export ELFEDIT="${LOCAL_TOOLCHAIN_PREFIX}-elfedit"
  export LD="${LOCAL_TOOLCHAIN_PREFIX}-ld"
  export NM="${LOCAL_TOOLCHAIN_PREFIX}-nm"
  export OBJCOPY="${LOCAL_TOOLCHAIN_PREFIX}-objcopy"
  export OBJDUMP="${LOCAL_TOOLCHAIN_PREFIX}-objdump"
  export RANLIB="${LOCAL_TOOLCHAIN_PREFIX}-ranlib"
  export READELF="${LOCAL_TOOLCHAIN_PREFIX}-readelf"
  export SIZE="${LOCAL_TOOLCHAIN_PREFIX}-size"
  export STRINGS="${LOCAL_TOOLCHAIN_PREFIX}-strings"
  export STRIP="${LOCAL_TOOLCHAIN_PREFIX}-strip"
  export CROSS_PREBUILT_PREFIX="${BASEDIR}/build/prebuilt/$(get_android_ndk_cmake_android_abi)/sysroot"
  export CROSS_PKG_CONFIG_PATH="${BASEDIR}/build/prebuilt/$(get_android_ndk_cmake_android_abi)/pkgconfig"
  export PKG_CONFIG_LIBDIR=$CROSS_PKG_CONFIG_PATH

  if [[ ! -d  ${CROSS_PREBUILT_PREFIX} ]]; then
     mkdir -p ${CROSS_PREBUILT_PREFIX}
  fi

  if [[ ! -d ${CROSS_PKG_CONFIG_PATH}} ]]; then
    mkdir -p ${CROSS_PKG_CONFIG_PATH}
  fi
}
