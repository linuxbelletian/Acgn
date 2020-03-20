#!/usr/bin/env bash

export ANDROID_SDK=${ANDROID_HOME}
export BASEDIR=`pwd`

rm -rf ${BASEDIR}/build
mkdir ${BASEDIR}/build
mkdir ${BASEDIR}/build/prebuilt

# API: $1   ARCH: $2
build_abi_with_api() {
    export API=${1}
    export ARCH=${2}

    ${BASEDIR}/buildscripts/build_libuuid.sh
    ${BASEDIR}/buildscripts/build_expat.sh
    ${BASEDIR}/buildscripts/build_libiconv.sh
    ${BASEDIR}/buildscripts/build_sdl2.sh
    ${BASEDIR}/buildscripts/build_fribidi.sh
    # chromaprint now not supported
#     ${BASEDIR}/buildscripts/build_chromaprint.sh

    ${BASEDIR}/buildscripts/build_libpng.sh
    ${BASEDIR}/buildscripts/build_freetype.sh
    ${BASEDIR}/buildscripts/build_fontconfig.sh
    ${BASEDIR}/buildscripts/build_libass.sh
    ${BASEDIR}/buildscripts/build_ffmpeg.sh
}

for VAR in arm64 x64 ; do
    build_abi_with_api 28 ${VAR}
done

cp -rf ${BASEDIR}/build/prebuilt/ ${BASEDIR}/prebuilt/

cd ./jni/

ln -s ../prebuilt/ prebuilt


