include_guard(GLOBAL)

set(librtsp_DIR ${CMAKE_CURRENT_SOURCE_DIR}/librtsp)
set(librtsp_INCLUDE_DIRECTORY ${librtsp_DIR}/include)
set(librtsp_SOURCE_DIRECTORY ${librtsp_DIR}/source)
set(librtsp_TEST_DIRECTORY ${librtsp_DIR}/test)

file(GLOB_RECURSE librtsp_HEADER_FILES
        ${librtsp_INCLUDE_DIRECTORY}/*.h
        ${librtsp_INCLUDE_DIRECTORY}/*.hxx
        ${librtsp_INCLUDE_DIRECTORY}/*.hpp
)
file(GLOB_RECURSE librtsp_SOURCE_FILES
        ${librtsp_SOURCE_DIRECTORY}/*.c
        ${librtsp_SOURCE_DIRECTORY}/*.cxx
        ${librtsp_SOURCE_DIRECTORY}/*.cpp
)

include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/librtp.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/libmpeg.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/libflv.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/libmov.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/libmkv.cmake)

find_package(ireader-sdk CONFIG REQUIRED)
find_path(SDK_INCLUDE_DIR "ireader/sdk/sys/path.h" REQUIRED)

add_library(rtsp ${librtsp_HEADER_FILES} ${librtsp_SOURCE_FILES})
target_link_libraries(rtsp PUBLIC flv rtp ireader::sdk::sdk ireader::sdk::aio ireader::sdk::http)
target_include_directories(rtsp PRIVATE ${librtsp_INCLUDE_DIRECTORY} ${librtp_INCLUDE_DIRECTORY} ${libmpeg_INCLUDE_DIRECTORY} ${libflv_INCLUDE_DIRECTORY} ${libmov_INCLUDE_DIRECTORY} ${libmkv_INCLUDE_DIRECTORY})
target_include_directories(rtsp PRIVATE ${SDK_INCLUDE_DIR}/ireader/sdk ${SDK_INCLUDE_DIR}/ireader/sdk/aio ${SDK_INCLUDE_DIR}/ireader/sdk/http)
target_compile_definitions(rtsp PRIVATE RTP_OVER_RTSP_TRY_TO_FIND_NEXT_PACKET FIX_DAHUA_AAC_FROM_G711)

list(APPEND IREADER_MEDIA_SERVER_EXPORT_LIBS rtsp)
install(DIRECTORY ${librtsp_INCLUDE_DIRECTORY}/ DESTINATION include/ireader/media-server/rtsp)
