
# Creates and names a library, sets it as either STATIC
# or SHARED, and provides the relative paths to its source code.
# You can define multiple libraries, and CMake builds them for you.
# Gradle automatically packages shared libraries with your APK.

#AUX_SOURCE_DIRECTORY(. src-player)

add_library( # Sets the name of the library.
        player

        # Sets the library as a shared library.
        SHARED

        # Provides a relative path to your source file(s).
#        ${src-player})
        native-lib.cpp)

# Searches for a specified prebuilt library and stores the path as a
# variable. Because CMake includes system libraries in the search path by
# default, you only need to specify the name of the public NDK library
# you want to add. CMake verifies that the library exists before
# completing its build.


find_library( # Sets the name of the path variable.
        log-lib

        # Specifies the name of the NDK library that
        # you want CMake to locate.
        log )

# Specifies libraries CMake should link to your target library. You
# can link multiple libraries, such as libraries you define in this
# build script, prebuilt third-party libraries, or system libraries.

#find_library(SDL2 SDL2)

target_link_libraries( # Specifies the target library.
        player
        # Links the target library to the log library
        # included in the NDK.
        ${log-lib}
#        -lpng
#        -lavfilter
#        -lavformat
#        -lavcodec
#        -lswresample
#        -lswscale
#        -lavutil
#        ${CMAKE_CURRENT_BINARY_DIR}/sysroot/lib/libavfilter.a
#        ${CMAKE_CURRENT_BINARY_DIR}/sysroot/lib/libavformat.a
#        ${CMAKE_CURRENT_BINARY_DIR}/sysroot/lib/libavcodec.a
#        ${CMAKE_CURRENT_BINARY_DIR}/sysroot/lib/libswresample.a
#        ${CMAKE_CURRENT_BINARY_DIR}/sysroot/lib/libswscale.a
#        ${CMAKE_CURRENT_BINARY_DIR}/sysroot/lib/libavutil.a
#        -lz
#        -lm
#        SDL2
        )

#add_dependencies(player EP-png EP-uuid EP-expat EP-ass EP-fribidi EP-ffmpeg)
add_dependencies(player EP-expat)