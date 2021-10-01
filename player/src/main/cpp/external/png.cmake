ExternalProject_Add(EP-png
        GIT_REPOSITORY https://github.com/glennrp/libpng.git
        GIT_TAG v1.6.37
        GIT_SHALLOW TRUE
        CMAKE_ARGS
            -DCMAKE_TOOLCHAIN_FILE=${ANDROID_NDK}/build/cmake/android.toolchain.cmake
            -DANDROID_ABI=${ANDROID_ABI}
            -DANDROID_NATIVE_API_LEVEL=${ANDROID_NATIVE_API_LEVEL}
            -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
            -DPNG_SHARED=OFF
            _DPNG_TESTS=OFF
            -DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR}/sysroot
        CMAKE_CACHE_ARGS
            -DCMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS}
        BUILD_BYPRODUCTS
            ${CMAKE_CURRENT_BINARY_DIR}/sysroot/lib/libpng.a
        )

set(LIBPNG png)