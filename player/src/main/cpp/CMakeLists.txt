# For more information about using CMake with Android Studio, read the
# documentation: https://d.android.com/studio/projects/add-native-code.html

# Sets the minimum version of CMake required to build the native library.

cmake_minimum_required(VERSION 3.21.2 FATAL_ERROR)

project(PlayCore)

set(EXTERNAL_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../../external")
include(ExternalProject)
set($ENV{PKG_CONFIG_LIBDIR} ${CMAKE_CURRENT_BINARY_DIR}/sysroot/lib/pkgconfig)

link_directories(${CMAKE_CURRENT_BINARY_DIR}/sysroot/lib)
include_directories(${CMAKE_CURRENT_BINARY_DIR}/sysroot/include)

include(abis.cmake)
include(external/expat.cmake)
include(external/png.cmake)
#include(external/uuid.cmake)
#include(external/ass.cmake)
include(external/fribidi.cmake)
#include(external/sdl2.cmake)
#include(external/ffmpeg.cmake)
#include(external/chromaprint.cmake)

#add_subdirectory(external)
add_subdirectory(player)
#add_subdirectory(SDL2)
add_dependencies(player
        EP-expat
        EP-png
#        EP-ass
        EP-fribidi
#        EP-uuid
#        EP-ffmpeg
#        EP-chromaprint
        )
