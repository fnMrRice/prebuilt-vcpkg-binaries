cmake_minimum_required(VERSION 3.29)

project(ireader-sdk VERSION 1.0.0 LANGUAGES C CXX)

option(BUILD_LIBRARY_AIO "Build library aio" ON)
option(BUILD_LIBRARY_HTTP "Build library http" ON)
option(BUILD_LIBRARY_ICE "Build library ice" ON)
option(BUILD_TESTING "Build tests" OFF)

if (WIN32)
    add_compile_definitions(OS_WINDOWS)
elseif (CMAKE_SYSTEM_NAME STREQUAL "Linux")
    add_compile_definitions(OS_LINUX)
elseif (APPLE)
    add_compile_definitions(OS_MAC)
elseif (ANDROID)
    add_compile_definitions(OS_ANDROID)
    add_compile_options(-Wno-incompatible-function-pointer-types)
endif ()

include(cmake/libsdk.cmake)
if (BUILD_LIBRARY_AIO)
    include(cmake/libaio.cmake)
endif ()
if (BUILD_LIBRARY_HTTP)
    include(cmake/libhttp.cmake)
endif ()
if (BUILD_LIBRARY_ICE)
    include(cmake/libice.cmake)
endif ()

foreach(library IN LISTS IREADER_SDK_EXPORT_LIBS)
    target_include_directories(${library} INTERFACE "$<INSTALL_INTERFACE:include>")
endforeach()

install(
        TARGETS ${IREADER_SDK_EXPORT_LIBS}
        EXPORT ireader-sdk-config
        ARCHIVE DESTINATION lib
        LIBRARY DESTINATION lib
        RUNTIME DESTINATION bin
)
install(
        EXPORT ireader-sdk-config
        DESTINATION lib/cmake/ireader-sdk
        NAMESPACE ireader::sdk::
)
