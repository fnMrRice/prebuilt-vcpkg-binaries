cmake_minimum_required(VERSION 3.29)
project(ireader-media-common VERSION 1.0.0 LANGUAGES C CXX)
set(IREADER_INCLUDE_PREFIX ireader/media-server)
include(cmake/library.cmake)
ireader_library(flv "${CMAKE_CURRENT_SOURCE_DIR}/libflv/include" libflv "${CMAKE_CURRENT_SOURCE_DIR}/libflv/source")
add_library(metadata INTERFACE)
target_include_directories(metadata INTERFACE
    "$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/metadata>"
    "$<INSTALL_INTERFACE:include/ireader/media-server/metadata>")
file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/metadata")
foreach(header IN ITEMS librtsp/include/rtsp-payloads.h libflv/include/flv-proto.h
    libmov/include/mov-format.h libmkv/include/mkv-format.h librtp/include/rtp-profile.h libmpeg/include/mpeg-proto.h)
    get_filename_component(filename "${header}" NAME)
    configure_file("${header}" "${CMAKE_CURRENT_BINARY_DIR}/metadata/${filename}" COPYONLY)
endforeach()
install(DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/metadata/" DESTINATION include/ireader/media-server/metadata)
list(APPEND IREADER_EXPORT_TARGETS metadata)
include(cmake/package.cmake)
