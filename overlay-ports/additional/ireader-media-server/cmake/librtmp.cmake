include_guard(GLOBAL)

set(librtmp_DIR ${CMAKE_CURRENT_SOURCE_DIR}/librtmp)
set(librtmp_INCLUDE_DIRECTORY ${librtmp_DIR}/include)
set(librtmp_SOURCE_DIRECTORY ${librtmp_DIR}/source)
set(librtmp_TEST_DIRECTORY ${librtmp_DIR}/test)

file(GLOB_RECURSE librtmp_HEADER_FILES
        ${librtmp_INCLUDE_DIRECTORY}/*.h
        ${librtmp_INCLUDE_DIRECTORY}/*.hxx
        ${librtmp_INCLUDE_DIRECTORY}/*.hpp
)
file(GLOB_RECURSE librtmp_SOURCE_FILES
        ${librtmp_SOURCE_DIRECTORY}/*.c
        ${librtmp_SOURCE_DIRECTORY}/*.cxx
        ${librtmp_SOURCE_DIRECTORY}/*.cpp
)

include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/libflv.cmake)

add_library(rtmp ${librtmp_HEADER_FILES} ${librtmp_SOURCE_FILES})
target_link_libraries(rtmp PUBLIC flv)
target_include_directories(rtmp PRIVATE ${librtmp_INCLUDE_DIRECTORY} ${libflv_INCLUDE_DIRECTORY})

list(APPEND IREADER_MEDIA_SERVER_EXPORT_LIBS rtmp)
install(DIRECTORY ${librtmp_INCLUDE_DIRECTORY}/ DESTINATION include/ireader/media-server/librtmp)
