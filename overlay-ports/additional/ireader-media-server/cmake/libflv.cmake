include_guard(GLOBAL)

set(libflv_DIR ${CMAKE_CURRENT_SOURCE_DIR}/libflv)
set(libflv_INCLUDE_DIRECTORY ${libflv_DIR}/include)
set(libflv_SOURCE_DIRECTORY ${libflv_DIR}/source)
set(libflv_TEST_DIRECTORY ${libflv_DIR}/test)

file(GLOB_RECURSE libflv_HEADER_FILES
        ${libflv_INCLUDE_DIRECTORY}/*.h
        ${libflv_INCLUDE_DIRECTORY}/*.hxx
        ${libflv_INCLUDE_DIRECTORY}/*.hpp
)
file(GLOB_RECURSE libflv_SOURCE_FILES
        ${libflv_SOURCE_DIRECTORY}/*.c
        ${libflv_SOURCE_DIRECTORY}/*.cxx
        ${libflv_SOURCE_DIRECTORY}/*.cpp
)

add_library(flv ${libflv_HEADER_FILES} ${libflv_SOURCE_FILES})
target_include_directories(flv PRIVATE ${libflv_INCLUDE_DIRECTORY})

list(APPEND IREADER_MEDIA_SERVER_EXPORT_LIBS flv)
install(DIRECTORY ${libflv_INCLUDE_DIRECTORY}/ DESTINATION include/ireader/media-server/libflv)

if (BUILD_TESTING)
    enable_testing()
    add_executable(amf0-test ${libflv_TEST_DIRECTORY}/amf0-test.c)
    add_executable(av1-flv-test ${libflv_TEST_DIRECTORY}/av1-flv-test.cpp)
    add_executable(flv2ts-test ${libflv_TEST_DIRECTORY}/flv2ts-test.cpp)
    add_executable(flv-parser-test ${libflv_TEST_DIRECTORY}/flv-parser-test.cpp)
    add_executable(flv-read-write-test ${libflv_TEST_DIRECTORY}/flv-read-write-test.cpp)
    add_executable(flv-reader-test ${libflv_TEST_DIRECTORY}/flv-reader-test.cpp)
    add_executable(h264-flv-test ${libflv_TEST_DIRECTORY}/h264-flv-test.cpp)
    add_executable(h265-flv-test ${libflv_TEST_DIRECTORY}/h265-flv-test.cpp)
    add_executable(http-flv-live ${libflv_TEST_DIRECTORY}/http-flv-live.cpp)
    add_executable(ts2flv-test ${libflv_TEST_DIRECTORY}/ts2flv-test.cpp)

    include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/libmpeg.cmake)
    include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/libmov.cmake)

    target_link_libraries(amf0-test PRIVATE flv)
    target_link_libraries(av1-flv-test PRIVATE flv)
    target_link_libraries(flv2ts-test PRIVATE flv mpeg)
    target_link_libraries(flv-parser-test PRIVATE flv mov)
    target_link_libraries(flv-read-write-test PRIVATE flv)
    target_link_libraries(flv-reader-test PRIVATE flv)
    target_link_libraries(h264-flv-test PRIVATE flv)
    target_link_libraries(h265-flv-test PRIVATE flv)
    target_link_libraries(http-flv-live PRIVATE flv)
    target_link_libraries(ts2flv-test PRIVATE flv mpeg)
endif ()
