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

LIB_NAME="ffmpeg"
VERSION="4.2.2"

# enable common function and enviroment variables
# shellcheck source=enviroment.sh
. "${BASEDIR}/buildscripts/enviroment.sh"



set_toolchain_paths

clear_lib_path $LIB_NAME

TARGET_CPU=""
TARGET_ARCH=""
ASM_FLAGS=""
case ${ARCH} in
    arm64)
        TARGET_CPU="armv8-a"
        TARGET_ARCH="aarch64"
        ASM_FLAGS="	--enable-neon --enable-asm --enable-inline-asm "
    ;;
    x64)
        TARGET_CPU="x86_64"
        TARGET_ARCH="x86_64"
        ASM_FLAGS="	--disable-neon --enable-asm --enable-inline-asm "
    ;;
esac

FEATURE_OPTION="--enable-iconv"
FEATURE_OPTION+=" --enable-libfribidi"
FEATURE_OPTION+=" --enable-libfreetype"
FEATURE_OPTION+=" --enable-libfontconfig"
FEATURE_OPTION+=" --enable-zlib"
FEATURE_OPTION+=" --enable-sdl2"
FEATURE_OPTION+=" --enable-libass"
FEATURE_OPTION+=" --enable-mediacodec"


TOOLCHAINS="--enable-pic --enable-cross-compile --target-os=android "
TOOLCHAINS+="--prefix=${CROSS_PREBUILT_PREFIX} "
TOOLCHAINS+="--cross-prefix=${LOCAL_TOOLCHAIN_PREFIX}- "
TOOLCHAINS+="--cc=${CC} "
TOOLCHAINS+="--cxx=${CXX} "
TOOLCHAINS+="--pkg-config=pkg-config "
#TOOLCHAINA+="--ranlib=${RANLIB} "
#TOOLCHAINA+="--ar=${AR} "
#TOOLCHAINA+="--as=${AS} "
#TOOLCHAINA+="--strip=${STRIP} "
TOOLCHAINS+="--arch=${TARGET_ARCH} "
TOOLCHAINS+="--cpu=${TARGET_CPU} "
TOOLCHAINS+="--extra-cflags=-fno-integrated-as "
TOOLCHAINS+="--extra-cflags=-fstrict-aliasing "
TOOLCHAINS+="--extra-cflags=-fPIC "
TOOLCHAINS+="--extra-cflags=-I${CROSS_PREBUILT_PREFIX}/include "
TOOLCHAINS+="--extra-cflags=-Wno-unused-function "
TOOLCHAINS+="--extra-cflags=-DBIONIC_IOCTL_NO_SIGNEDNESS_OVERLOAD "
TOOLCHAINS+="--extra-ldflags=-fuse-ld=gold "
TOOLCHAINS+="--extra-ldflags=-lz "
TOOLCHAINS+="--extra-ldflags=-lc "
TOOLCHAINS+="--extra-ldflags=-lm "
TOOLCHAINS+="--extra-ldflags=-ldl "
TOOLCHAINS+="--extra-ldflags=-lpng16 "
TOOLCHAINS+="--extra-ldflags=-llog "
TOOLCHAINS+="--extra-ldflags=-Wl,--no-undefined "
TOOLCHAINS+="--extra-ldflags=-lGLESv1_CM "
TOOLCHAINS+="--extra-ldflags=-lGLESv2 "
TOOLCHAINS+="--extra-ldflags=-landroid "
TOOLCHAINS+="--extra-ldflags=-Wl,--exclude-libs,libgcc.a "
TOOLCHAINS+="--extra-ldflags=-Wl,--exclude-libs,libunwind.a "
TOOLCHAINS+="--extra-ldflags=-O2 "
TOOLCHAINS+="--extra-ldflags=-ffunction-sections "
TOOLCHAINS+="--extra-ldflags=-fdata-sections "
TOOLCHAINS+="--extra-ldflags=-finline-functions "
TOOLCHAINS+="--extra-libs=-L${CROSS_PREBUILT_PREFIX}/lib "

pushd "${BASEDIR}/build/${LIB_NAME}" || exit

"${BASEDIR}"/external/${LIB_NAME}-${VERSION}/configure -h > ffmpeg-help.txt

"${BASEDIR}"/external/${LIB_NAME}-${VERSION}/configure \
    "${TOOLCHAINS}" \
    "${ASM_FLAGS}" \
    --enable-version3 \
    --enable-pic \
    --enable-jni \
    --enable-optimizations \
    --enable-swscale \
    --disable-shared \
    --disable-v4l2-m2m \
    --disable-outdev=v4l2 \
    --disable-outdev=fbdev \
    --disable-indev=v4l2 \
    --disable-indev=fbdev \
    "${SIZE_OPTIONS}" \
    --disable-openssl \
    --disable-xmm-clobber-test \
    "${DEBUG_OPTIONS}" \
    --disable-neon-clobber-test \
    --disable-programs \
    --disable-postproc \
    --disable-doc \
    --disable-htmlpages \
    --disable-manpages \
    --disable-podpages \
    --disable-txtpages \
    --enable-static \
    --disable-sndio \
    --disable-schannel \
    --disable-securetransport \
    --disable-xlib \
    --disable-cuda \
    --disable-cuvid \
    --disable-nvenc \
    --disable-vaapi \
    --disable-vdpau \
    --disable-videotoolbox \
    --disable-audiotoolbox \
    --disable-appkit \
    --disable-alsa \
    --disable-cuda \
    --disable-cuvid \
    --disable-nvenc \
    --disable-vaapi \
    --disable-vdpau \
    --disable-x86asm \
    "${FEATURE_OPTION}" || exit 1

make -j"$(get_cpu_count)" || exit 1

make install

popd || exit
