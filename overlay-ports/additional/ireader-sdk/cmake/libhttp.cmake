include_guard(GLOBAL)

set(libhttp_DIR ${CMAKE_CURRENT_SOURCE_DIR}/libhttp)
set(libhttp_INCLUDE_DIRECTORY ${libhttp_DIR}/include)
set(libhttp_SOURCE_DIRECTORY ${libhttp_DIR}/source)
set(libhttp_TEST_DIRECTORY ${libhttp_DIR}/test)

file(GLOB_RECURSE libhttp_HEADER_FILES
        ${libhttp_INCLUDE_DIRECTORY}/*.h
        ${libhttp_INCLUDE_DIRECTORY}/*.hxx
        ${libhttp_INCLUDE_DIRECTORY}/*.hpp
)
file(GLOB_RECURSE libhttp_SOURCE_FILES
        ${libhttp_SOURCE_DIRECTORY}/*.c
        ${libhttp_SOURCE_DIRECTORY}/*.cxx
        ${libhttp_SOURCE_DIRECTORY}/*.cpp
)
list(APPEND libaio_SOURCE_FILES
        ${CMAKE_CURRENT_SOURCE_DIR}/source/digest/sha1.c
        ${CMAKE_CURRENT_SOURCE_DIR}/source/base64.c
        ${CMAKE_CURRENT_SOURCE_DIR}/source/port/sysdirlist.c
)

include(cmake/libsdk.cmake)
include(cmake/libaio.cmake)

add_library(http ${libhttp_HEADER_FILES} ${libhttp_SOURCE_FILES})
target_include_directories(http PRIVATE ${libhttp_INCLUDE_DIRECTORY} ${libsdk_INCLUDE_DIRECTORY} ${libaio_INCLUDE_DIRECTORY})
target_link_libraries(http PUBLIC sdk aio)

list(APPEND IREADER_SDK_EXPORT_LIBS http)
install(DIRECTORY ${libhttp_INCLUDE_DIRECTORY}/
        DESTINATION include/ireader/sdk/http
        FILES_MATCHING REGEX "^.+\.h(pp|xx)?$"
)
