include_guard(GLOBAL)

set(libmov_DIR ${CMAKE_CURRENT_SOURCE_DIR}/libmov)
set(libmov_INCLUDE_DIRECTORY ${libmov_DIR}/include)
set(libmov_SOURCE_DIRECTORY ${libmov_DIR}/source)
set(libmov_TEST_DIRECTORY ${libmov_DIR}/test)

file(GLOB_RECURSE libmov_HEADER_FILES
        ${libmov_INCLUDE_DIRECTORY}/*.h
        ${libmov_INCLUDE_DIRECTORY}/*.hxx
        ${libmov_INCLUDE_DIRECTORY}/*.hpp
)
file(GLOB_RECURSE libmov_SOURCE_FILES
        ${libmov_SOURCE_DIRECTORY}/*.c
        ${libmov_SOURCE_DIRECTORY}/*.cxx
        ${libmov_SOURCE_DIRECTORY}/*.cpp
)

add_library(mov ${libmov_HEADER_FILES} ${libmov_SOURCE_FILES})
target_include_directories(mov PRIVATE ${libmov_INCLUDE_DIRECTORY})

list(APPEND IREADER_MEDIA_SERVER_EXPORT_LIBS mov)
install(DIRECTORY ${libmov_INCLUDE_DIRECTORY}/ DESTINATION include/ireader/media-server/libmov)
