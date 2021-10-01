## More information about variables please check "ndkroot/build/cmake/android.toolchain.cmake".
## Also see https://developer.android.com/ndk/guides/cmake

if (ANDROID_ABI)
    if (${ANDROID_ABI} STREQUAL "armeabi-v7a")
        set(TARGET "armv7a-linux-androideabi")
    elseif (${ANDROID_ABI} STREQUAL "arm64-v8a")
        set(TARGET "aarch64-linux-android")
    elseif (${ANDROID_ABI} STREQUAL "x86")
        set(TARGET "i686-linux-android")
    elseif (${ANDROID_ABI} STREQUAL "x86_64")
        set(TARGET "x86_64-linux-android")
    else ()
        MESSAGE(FATAL_ERROR "Can't get android_abi: ${ANDROID_ABI}")
    endif ()
else ()
    MESSAGE(FATAL_ERROR "Can't get android_abi")
endif ()

set(CMAKE_DWP ${ANDROID_TOOLCHAIN_ROOT}/bin/llvm-dwp)
set(CMAKE_SIZE ${ANDROID_TOOLCHAIN_ROOT}/bin/llvm-size)
set(CMAKE_STRINGS ${ANDROID_TOOLCHAIN_ROOT}/bin/llvm-strings)
set(CMAKE_AS ${CMAKE_CXX_ANDROID_TOOLCHAIN_PREFIX}as)
set(CMAKE_READOJB ${ANDROID_TOOLCHAIN_ROOT}/bin/llvm-readojb)
set(CMAKE_YAMS ${ANDROID_TOOLCHAIN_ROOT}/bin/yasn)

set(TOOLCHAINS
        CC=${ANDROID_TOOLCHAIN_ROOT}/bin/${TARGET}${ANDROID_NATIVE_API_LEVEL}-clang
        CXX=${ANDROID_TOOLCHAIN_ROOT}/bin/${TARGET}${ANDROID_NATIVE_API_LEVEL}-clang++
        CFLAGS=${CMAKE_C_FLAGS}
        CXXFLAGS=${CMAKE_CXX_FLAGS}
        LD=${CMAKE_LINKER}
        AR=${CMAKE_AR}
        NM=${CMAKE_NM}
        AS=${CMAKE_AS}
        RANLIB=${CMAKE_RANLIB}
        STRIP=${CMAKE_STRIP}
        OBJDUMP=${CMAKE_OBJDUMP}
        ADDR2LINE=${CMAKE_ADDR2LINE}
        OBJCOPY=${CMAKE_OBJCOPY}
        READELF=${CMAKE_READELF}
        DWP=${CMAKE_DWP}
        SIZE=${CMAKE_SIZE}
        STRINGS=${CMAKE_STRINGS}
        )