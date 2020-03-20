set(E_NAME "expat")
set(E_SOURCE_DIR_NAME "expat-2.2.7")

ExternalProject_Add(EP-${E_NAME}
        PREFIX
            ${CMAKE_CURRENT_BINARY_DIR}/${E_NAME}
        INSTALL_DIR
            ${CMAKE_CURRENT_BINARY_DIR}/${E_NAME}
        SOURCE_DIR
            ${EXTERNAL_DIR}/${E_SOURCE_DIR_NAME}
        CMAKE_ARGS
            -DCMAKE_TOOLCHAIN_FILE=${ANDROID_NDK}/build/cmake/android.toolchain.cmake
            -DANDROID_ABI=${ANDROID_ABI}
            -DANDROID_NATIVE_API_LEVEL=${ANDROID_NATIVE_API_LEVEL}
            -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
            -DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR}/sysroot
            -DBUILD_shared=OFF
            -DBUILD_doc=OFF
        CMAKE_CACHE_ARGS
            -DCMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS}
        BUILD_ALWAYS
            1
        BUILD_BYPRODUCTS
            ${CMAKE_CURRENT_BINARY_DIR}/sysroot/lib/libexpat.a
        )

set(LIBEXPAT expat)