include_guard(GLOBAL)

set(libmpeg_DIR ${CMAKE_CURRENT_SOURCE_DIR}/libmpeg)
set(libmpeg_INCLUDE_DIRECTORY ${libmpeg_DIR}/include)
set(libmpeg_SOURCE_DIRECTORY ${libmpeg_DIR}/source)
set(libmpeg_TEST_DIRECTORY ${libmpeg_DIR}/test)

file(GLOB_RECURSE libmpeg_HEADER_FILES
        ${libmpeg_INCLUDE_DIRECTORY}/*.h
        ${libmpeg_INCLUDE_DIRECTORY}/*.hxx
        ${libmpeg_INCLUDE_DIRECTORY}/*.hpp
)
file(GLOB_RECURSE libmpeg_SOURCE_FILES
        ${libmpeg_SOURCE_DIRECTORY}/*.c
        ${libmpeg_SOURCE_DIRECTORY}/*.cxx
        ${libmpeg_SOURCE_DIRECTORY}/*.cpp
)

add_library(mpeg ${libmpeg_HEADER_FILES} ${libmpeg_SOURCE_FILES})
target_include_directories(mpeg PRIVATE ${libmpeg_INCLUDE_DIRECTORY})
target_compile_definitions(mpeg PRIVATE MPEG_H26X_VERIFY MPEG_ZERO_PAYLOAD_LENGTH MPEG_DAHUA_AAC_FROM_G711 MPEG_KEDA_H265_FROM_H264)

list(APPEND IREADER_MEDIA_SERVER_EXPORT_LIBS mpeg)
install(DIRECTORY ${libmpeg_INCLUDE_DIRECTORY}/ DESTINATION include/ireader/media-server/libmpeg)
