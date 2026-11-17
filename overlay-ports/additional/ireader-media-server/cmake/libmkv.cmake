include_guard(GLOBAL)

set(libmkv_DIR ${CMAKE_CURRENT_SOURCE_DIR}/libmkv)
set(libmkv_INCLUDE_DIRECTORY ${libmkv_DIR}/include)
set(libmkv_SOURCE_DIRECTORY ${libmkv_DIR}/src)
set(libmkv_TEST_DIRECTORY ${libmkv_DIR}/test)

file(GLOB_RECURSE libmkv_HEADER_FILES
        ${libmkv_INCLUDE_DIRECTORY}/*.h
        ${libmkv_INCLUDE_DIRECTORY}/*.hxx
        ${libmkv_INCLUDE_DIRECTORY}/*.hpp
)
file(GLOB_RECURSE libmkv_SOURCE_FILES
        ${libmkv_SOURCE_DIRECTORY}/*.c
        ${libmkv_SOURCE_DIRECTORY}/*.cxx
        ${libmkv_SOURCE_DIRECTORY}/*.cpp
)

add_library(mkv ${libmov_HEADER_FILES} ${libmov_SOURCE_FILES})
target_include_directories(mkv PRIVATE ${libmov_INCLUDE_DIRECTORY})

list(APPEND IREADER_MEDIA_SERVER_EXPORT_LIBS mkv)
install(DIRECTORY ${libmkv_INCLUDE_DIRECTORY}/ DESTINATION include/ireader/media-server/libmkv)
