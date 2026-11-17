include_guard(GLOBAL)

set(libhls_DIR ${CMAKE_CURRENT_SOURCE_DIR}/libhls)
set(libhls_INCLUDE_DIRECTORY ${libhls_DIR}/include)
set(libhls_SOURCE_DIRECTORY ${libhls_DIR}/source)
set(libhls_TEST_DIRECTORY ${libhls_DIR}/test)

file(GLOB_RECURSE libhls_HEADER_FILES
        ${libhls_INCLUDE_DIRECTORY}/*.h
        ${libhls_INCLUDE_DIRECTORY}/*.hxx
        ${libhls_INCLUDE_DIRECTORY}/*.hpp
)
file(GLOB_RECURSE libhls_SOURCE_FILES
        ${libhls_SOURCE_DIRECTORY}/*.c
        ${libhls_SOURCE_DIRECTORY}/*.cxx
        ${libhls_SOURCE_DIRECTORY}/*.cpp
)

include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/libmov.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/libmpeg.cmake)

add_library(hls ${libhls_HEADER_FILES} ${libhls_SOURCE_FILES})
target_link_libraries(hls PUBLIC mpeg mov)
target_include_directories(hls PRIVATE ${libhls_INCLUDE_DIRECTORY} ${libmpeg_INCLUDE_DIRECTORY} ${libmov_INCLUDE_DIRECTORY})

list(APPEND IREADER_MEDIA_SERVER_EXPORT_LIBS hls)
install(DIRECTORY ${libhls_INCLUDE_DIRECTORY}/ DESTINATION include/ireader/media-server/libhls)
