## More information about variables please check "ndkroot/build/cmake/android.toolchain.cmake".
## Also see https://developer.android.com/ndk/guides/cmake

set(E_NAME "fribidi")

ExternalProject_Add(EP-${E_NAME}
        GIT_REPOSITORY https://github.com/fribidi/fribidi.git
        GIT_TAG v1.0.11
        GIT_SHALLOW TRUE
        CONFIGURE_COMMAND
        <SOURCE_DIR>/configure ${TOOLCHAINS}
        --prefix=${CMAKE_CURRENT_BINARY_DIR}/sysroot
        --with-pic
        --enable-static
        --disable-deprecated
        --disable-debug
        --disable-shared
        --disable-fast-install
        --host=${TARGET}

        BUILD_BYPRODUCTS
        ${CMAKE_CURRENT_BINARY_DIR}/sysroot/lib/libfribidi.a
        )

ExternalProject_Add_Step(EP-${E_NAME} autogen
        COMMAND              <SOURCE_DIR>/autogen.sh
        DEPENDEES            update
        DEPENDERS            configure
        )

set(LIBASS ${E_NAME})
