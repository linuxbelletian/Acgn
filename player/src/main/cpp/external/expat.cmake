set(E_NAME "expat")

ExternalProject_Add(EP-${E_NAME}
        GIT_REPOSITORY https://github.com/libexpat/libexpat.git
        GIT_TAG R_2_4_1
        GIT_SHALLOW TRUE
        SOURCE_SUBDIR expat
        CMAKE_ARGS
            -DCMAKE_TOOLCHAIN_FILE=${ANDROID_NDK}/build/cmake/android.toolchain.cmake
            -DANDROID_ABI=${ANDROID_ABI}
            -DANDROID_NATIVE_API_LEVEL=${ANDROID_NATIVE_API_LEVEL}
            -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
            -DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR}/sysroot
            -DEXPAT_BUILD_DOCS=OFF
            -DEXPAT_BUILD_TOOLS=OFF
            -DEXPAT_BUILD_EXAMPLES=OFF
            -DEXPAT_BUILD_TESTS=OFF
            -DEXPAT_SHARED_LIBS=OFF
        CMAKE_CACHE_ARGS
            -DCMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS}
        BUILD_BYPRODUCTS
            ${CMAKE_CURRENT_BINARY_DIR}/sysroot/lib/libexpat.a
        )

set(LIBEXPAT expat)