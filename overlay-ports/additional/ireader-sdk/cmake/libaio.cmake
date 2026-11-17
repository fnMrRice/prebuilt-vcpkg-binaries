include_guard(GLOBAL)

set(libaio_DIR ${CMAKE_CURRENT_SOURCE_DIR}/libaio)
set(libaio_INCLUDE_DIRECTORY ${libaio_DIR}/include)
set(libaio_SOURCE_DIRECTORY ${libaio_DIR}/src)
set(libaio_TEST_DIRECTORY ${libaio_DIR}/test)

file(GLOB_RECURSE libaio_HEADER_FILES
        ${libaio_INCLUDE_DIRECTORY}/*.h
        ${libaio_INCLUDE_DIRECTORY}/*.hxx
        ${libaio_INCLUDE_DIRECTORY}/*.hpp
)
file(GLOB_RECURSE libaio_SOURCE_FILES
        ${libaio_SOURCE_DIRECTORY}/*.c
        ${libaio_SOURCE_DIRECTORY}/*.cxx
        ${libaio_SOURCE_DIRECTORY}/*.cpp
)
list(APPEND libaio_SOURCE_FILES
        ${CMAKE_CURRENT_SOURCE_DIR}/source/port/aio-socket-epoll.c
        ${CMAKE_CURRENT_SOURCE_DIR}/source/twtimer.c
)

include(cmake/libsdk.cmake)

add_library(aio ${libaio_HEADER_FILES} ${libaio_SOURCE_FILES})
target_include_directories(aio PRIVATE ${libaio_INCLUDE_DIRECTORY} ${libsdk_INCLUDE_DIRECTORY})
target_link_libraries(aio PUBLIC sdk)

list(APPEND IREADER_SDK_EXPORT_LIBS aio)
install(DIRECTORY ${libaio_INCLUDE_DIRECTORY}/
        DESTINATION include/ireader/sdk/aio
        FILES_MATCHING REGEX "^.+\.h(pp|xx)?$"
)
