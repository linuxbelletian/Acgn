## More information about variables please check "ndkroot/build/cmake/android.toolchain.cmake".
## Also see https://developer.android.com/ndk/guides/cmake

if(ANDROID_ABI)
    if(${ANDROID_ABI} STREQUAL "armeabi-v7a")
        set(TARGET "armv7a-linux-androideabi")
    elseif(${ANDROID_ABI} STREQUAL "arm64-v8a")
        set(TARGET "aarch64-linux-android")
    elseif(${ANDROID_ABI} STREQUAL "x86")
        set(TARGET "i686-linux-android")
    elseif(${ANDROID_ABI} STREQUAL "x86_64")
        set(TARGET "x86_64-linux-android")
    else()
        MESSAGE(FATAL_ERROR "Can't get android_abi: ${ANDROID_ABI}")
    endif()
else()
    MESSAGE(FATAL_ERROR "Can't get android_abi")
endif()

set(BINUTIL_ROOT_PATH ${ANDROID_TOOLCHAIN_ROOT}/bin/${ANDROID_TOOLCHAIN_NAME}-)