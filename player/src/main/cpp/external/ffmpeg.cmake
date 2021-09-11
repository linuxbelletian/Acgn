## More information about variables please check "ndkroot/build/cmake/android.toolchain.cmake".
## Also see https://developer.android.com/ndk/guides/cmake

set(E_NAME "ffmpeg")
set(E_SOURCE_DIR_NAME "ffmpeg-4.2.2")
#MESSAGE(FATAL_ERROR "LINKER ${CMAKE_LINKER}")

ExternalProject_Add(EP-${E_NAME}
        SOURCE_DIR
        ${EXTERNAL_DIR}/${E_SOURCE_DIR_NAME}
        CONFIGURE_COMMAND

        ${EXTERNAL_DIR}/${E_SOURCE_DIR_NAME}/configure --help
#  export CC=${ANDROID_TOOLCHAIN_ROOT}/bin/${TARGET}${ANDROID_NATIVE_API_LEVEL}-clang
        #        export CXX=${ANDROID_TOOLCHAIN_ROOT}/bin/${TARGET}${ANDROID_NATIVE_API_LEVEL}-clang++
        COMMAND
        ${EXTERNAL_DIR}/${E_SOURCE_DIR_NAME}/configure
        --prefix=${CMAKE_CURRENT_BINARY_DIR}/sysroot
        --enable-version3
        --disable-programs
        --disable-doc
        --enable-jni
        --disable-xlib

        # Toolchian Options
        --arch=${CMAKE_ANDROID_ARCH}
        --enable-cross-compile
        --target-os=android
        --cross-prefix=${ANDROID_TOOLCHAIN_PREFIX}
        --cc=${ANDROID_TOOLCHAIN_ROOT}/bin/${TARGET}${ANDROID_NATIVE_API_LEVEL}-clang
        --cxx=${ANDROID_TOOLCHAIN_ROOT}/bin/${TARGET}${ANDROID_NATIVE_API_LEVEL}-clang++
        --ld=${CMAKE_LINKER}
        --nm=${CMAKE_NM}
        --ar=${CMAKE_AR}
        --as=${ANDROID_TOOLCHAIN_PREFIX}as
        --pkg-config=pkg-config
        --ranlib=${CMAKE_RANLIB}
        --strip=${CMAKE_STRIP}
        --disable-asm
        --disable-x86asm

        COMMAND
        ${EXTERNAL_DIR}/../buildscripts/ffmpeg_fix_header.sh

        BUILD_BYPRODUCTS
        ${CMAKE_CURRENT_BINARY_DIR}/sysroot/lib/libavformat.a
        ${CMAKE_CURRENT_BINARY_DIR}/sysroot/lib/libavcodec.a
        ${CMAKE_CURRENT_BINARY_DIR}/sysroot/lib/libavdevice.a
        ${CMAKE_CURRENT_BINARY_DIR}/sysroot/lib/libavfilter.a
        ${CMAKE_CURRENT_BINARY_DIR}/sysroot/lib/libavavutil.a
        ${CMAKE_CURRENT_BINARY_DIR}/sysroot/lib/libswscale.a
        ${CMAKE_CURRENT_BINARY_DIR}/sysroot/lib/libswresample.a
        )

