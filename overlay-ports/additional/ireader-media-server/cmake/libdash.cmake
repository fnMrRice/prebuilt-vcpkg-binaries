include_guard(GLOBAL)

set(libdash_DIR ${CMAKE_CURRENT_SOURCE_DIR}/libdash)
set(libdash_INCLUDE_DIRECTORY ${libdash_DIR}/include)
set(libdash_SOURCE_DIRECTORY ${libdash_DIR}/src)
set(libdash_TEST_DIRECTORY ${libdash_DIR}/test)

file(GLOB_RECURSE libdash_HEADER_FILES
        ${libdash_INCLUDE_DIRECTORY}/*.h
        ${libdash_INCLUDE_DIRECTORY}/*.hxx
        ${libdash_INCLUDE_DIRECTORY}/*.hpp
)
file(GLOB_RECURSE libdash_SOURCE_FILES
        ${libdash_SOURCE_DIRECTORY}/*.c
        ${libdash_SOURCE_DIRECTORY}/*.cxx
        ${libdash_SOURCE_DIRECTORY}/*.cpp
)

include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/libmov.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/libhls.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/libflv.cmake)

add_library(dash ${libdash_HEADER_FILES} ${libdash_SOURCE_FILES})
target_link_libraries(dash PUBLIC mov hls flv)
target_include_directories(dash PRIVATE ${libdash_INCLUDE_DIRECTORY} ${libmov_INCLUDE_DIRECTORY} ${libhls_INCLUDE_DIRECTORY} ${libflv_INCLUDE_DIRECTORY})

list(APPEND IREADER_MEDIA_SERVER_EXPORT_LIBS dash)
install(DIRECTORY ${libdash_INCLUDE_DIRECTORY}/ DESTINATION include/ireader/media-server/libdash)

if (BUILD_TESTING)
    enable_testing()
    add_executable(dash-dynamic-test ${libdash_TEST_DIRECTORY}/dash-dynamic-test.cpp)
    add_executable(dash-static-test ${libdash_TEST_DIRECTORY}/dash-static-test.cpp)

    include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/libmpeg.cmake)

    target_link_libraries(dash-dynamic-test PRIVATE dash mov flv mpeg)
    target_link_libraries(dash-static-test PRIVATE dash mov)
endif ()
