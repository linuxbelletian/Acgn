## More information about variables please check "ndkroot/build/cmake/android.toolchain.cmake".
## Also see https://developer.android.com/ndk/guides/cmake

set(E_NAME "ass")
set(E_SOURCE_DIR_NAME "libass-0.14.0")

ExternalProject_Add(EP-${E_NAME}
        PREFIX
        ${CMAKE_CURRENT_BINARY_DIR}/${E_NAME}
        SOURCE_DIR
        ${EXTERNAL_DIR}/${E_SOURCE_DIR_NAME}
        CONFIGURE_COMMAND
        export CC=${ANDROID_TOOLCHAIN_ROOT}/bin/${TARGET}${ANDROID_NATIVE_API_LEVEL}-clang
        export CXX=${ANDROID_TOOLCHAIN_ROOT}/bin/${TARGET}${ANDROID_NATIVE_API_LEVEL}-clang++
        export CFLAGS=${CMAKE_C_FLAGS}
        export CXXFLAGS=${CMAKE_CXX_FLAGS}
        export LD=${CMAKE_LINKER}
        export AR=${CMAKE_AR}
        export NM=${CMAKE_NM}
        export AS=${ANDROID_TOOLCHAIN_PREFIX}as
        export RANLIB=${CMAKE_RANLIB}
        export STRIP=${CMAKE_STRIP}
        export OBJDUMP=${CMAKE_OBJDUMP}
        export ADDR2LINE=${ANDROID_TOOLCHAIN_PREFIX}addr2line
        export DWP=${ANDROID_TOOLCHAIN_PREFIX}dwp
        export ELFEDIT=${ANDROID_TOOLCHAIN_PREFIX}elfedit
        export OBJCOPY=${CMAKE_OBJCOPY}
        export READELF=${ANDROID_TOOLCHAIN_PREFIX}readelf
        export SIZE=${ANDROID_TOOLCHAIN_PREFIX}size
        export STRINGS=${ANDROID_TOOLCHAIN_PREFIX}strings
        COMMAND
        ${EXTERNAL_DIR}/${E_SOURCE_DIR_NAME}/configure
        --prefix=${CMAKE_CURRENT_BINARY_DIR}/sysroot
        --with-pic
        --enable-static
        --disable-coretext
        --disable-profile
        --disable-libtool-lock
        --disable-harfbuzz
        --disable-shared
        --disable-fast-install
        --host=${TARGET}
        BUILD_BYPRODUCTS
        ${CMAKE_CURRENT_BINARY_DIR}/sysroot/lib/libass.a
        )

link_directories(${CMAKE_CURRENT_BINARY_DIR}/sysroot/lib)
include_directories(${CMAKE_CURRENT_BINARY_DIR}/sysroot/include)
set(LIBASS ass)
