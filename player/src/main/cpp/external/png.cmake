set(E_NAME "png")
set(E_SOURCE_DIR_NAME "libpng-1.6.37")

ExternalProject_Add(EP-${E_NAME}
        PREFIX
            ${CMAKE_CURRENT_BINARY_DIR}/sysroot
        INSTALL_DIR
            ${CMAKE_CURRENT_BINARY_DIR}/sysroot
        SOURCE_DIR
            ${EXTERNAL_DIR}/${E_SOURCE_DIR_NAME}
        CMAKE_ARGS
            -DCMAKE_TOOLCHAIN_FILE=${ANDROID_NDK}/build/cmake/android.toolchain.cmake
            -DANDROID_ABI=${ANDROID_ABI}
            -DANDROID_NATIVE_API_LEVEL=${ANDROID_NATIVE_API_LEVEL}
            -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
            -DPNG_SHARED=OFF
            -DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR}/sysroot
        CMAKE_CACHE_ARGS
            -DCMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS}
        BUILD_ALWAYS
            1
        BUILD_BYPRODUCTS
            ${CMAKE_CURRENT_BINARY_DIR}/sysroot/lib/libpng.a
        )

set(LIBPNG png)