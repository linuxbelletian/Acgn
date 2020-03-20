## More information about variables please check "ndkroot/build/cmake/android.toolchain.cmake".
## Also see https://developer.android.com/ndk/guides/cmake

set(E_NAME "ffmpeg")
set(E_SOURCE_DIR_NAME "ffmpeg-4.2.2")
#MESSAGE(FATAL_ERROR "${ANDROID_TOOLCHAIN_PREFIX}")

ExternalProject_Add(EP-${E_NAME}
        PREFIX
        ${CMAKE_CURRENT_BINARY_DIR}/${E_NAME}
        SOURCE_DIR
        ${EXTERNAL_DIR}/${E_SOURCE_DIR_NAME}
        CONFIGURE_COMMAND

#        ${EXTERNAL_DIR}/${E_SOURCE_DIR_NAME}/configure --help
#
#        COMMAND
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
        --extra-cflags=${CMAKE_C_FLAGS}
        --extra-cxxflags=${CMAKE_CXX_FLAGS}
        --enable-pic
        --disable-x86asm
        BUILD_BYPRODUCTS
        ${CMAKE_CURRENT_BINARY_DIR}/sysroot/lib/libavformat.a
        ${CMAKE_CURRENT_BINARY_DIR}/sysroot/lib/libavcodec.a
        ${CMAKE_CURRENT_BINARY_DIR}/sysroot/lib/libavdevice.a
        ${CMAKE_CURRENT_BINARY_DIR}/sysroot/lib/libavfilter.a
        ${CMAKE_CURRENT_BINARY_DIR}/sysroot/lib/libavavutil.a
        ${CMAKE_CURRENT_BINARY_DIR}/sysroot/lib/libswscale.a
        ${CMAKE_CURRENT_BINARY_DIR}/sysroot/lib/libswresample.a
        )

