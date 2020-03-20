# For more information about using CMake with Android Studio, read the
# documentation: https://d.android.com/studio/projects/add-native-code.html

# Sets the minimum version of CMake required to build the native library.

cmake_minimum_required(VERSION 3.10.0 FATAL_ERROR)

set(EXTERNAL_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../../external")
include(ExternalProject)


include(abis.cmake)
include(external/expat.cmake)
include(external/png.cmake)
include(external/uuid.cmake)
include(external/ass.cmake)
include(external/fribidi.cmake)
include(external/ffmpeg.cmake)

add_subdirectory(external)
add_subdirectory(player)
