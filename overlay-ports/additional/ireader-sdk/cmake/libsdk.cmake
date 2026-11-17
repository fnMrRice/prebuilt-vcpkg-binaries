include_guard(GLOBAL)

set(libsdk_DIR ${CMAKE_CURRENT_SOURCE_DIR})
set(libsdk_INCLUDE_DIRECTORY ${libsdk_DIR}/include)
set(libsdk_SOURCE_DIRECTORY ${libsdk_DIR}/source)
set(libsdk_TEST_DIRECTORY ${libsdk_DIR}/test)

file(GLOB_RECURSE libsdk_HEADER_FILES
        ${libsdk_INCLUDE_DIRECTORY}/*.h
        ${libsdk_INCLUDE_DIRECTORY}/*.hxx
        ${libsdk_INCLUDE_DIRECTORY}/*.hpp
)
file(GLOB libsdk_SOURCE_FILES
        ${libsdk_SOURCE_DIRECTORY}/*.c
        ${libsdk_SOURCE_DIRECTORY}/*.cxx
        ${libsdk_SOURCE_DIRECTORY}/*.cpp
        ${libsdk_SOURCE_DIRECTORY}/digest/*.c
        ${libsdk_SOURCE_DIRECTORY}/digest/*.cxx
        ${libsdk_SOURCE_DIRECTORY}/digest/*.cpp
)
list(APPEND libsdk_SOURCE_FILES
        ${CMAKE_CURRENT_SOURCE_DIR}/source/port/ip-route.c
        ${CMAKE_CURRENT_SOURCE_DIR}/source/port/sysdirlist.c
        ${CMAKE_CURRENT_SOURCE_DIR}/source/port/file-watcher-linux.c
)

add_library(sdk ${libsdk_HEADER_FILES} ${libsdk_SOURCE_FILES})
target_include_directories(sdk PRIVATE ${libsdk_INCLUDE_DIRECTORY})

list(APPEND IREADER_SDK_EXPORT_LIBS sdk)
install(DIRECTORY ${libsdk_INCLUDE_DIRECTORY}/
        DESTINATION include/ireader/sdk
        FILES_MATCHING REGEX "^.+\.h(pp|xx)?$"
)
