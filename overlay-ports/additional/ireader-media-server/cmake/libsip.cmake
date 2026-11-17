include_guard(GLOBAL)

set(libsip_DIR ${CMAKE_CURRENT_SOURCE_DIR}/libsip)
set(libsip_INCLUDE_DIRECTORY ${libsip_DIR}/include)
set(libsip_SOURCE_DIRECTORY ${libsip_DIR}/src)
set(libsip_TEST_DIRECTORY ${libsip_DIR}/test)

file(GLOB_RECURSE libsip_HEADER_FILES
        ${libsip_INCLUDE_DIRECTORY}/*.h
        ${libsip_INCLUDE_DIRECTORY}/*.hxx
        ${libsip_INCLUDE_DIRECTORY}/*.hpp
)
file(GLOB_RECURSE libsip_SOURCE_FILES
        ${libsip_SOURCE_DIRECTORY}/*.c
        ${libsip_SOURCE_DIRECTORY}/*.cxx
        ${libsip_SOURCE_DIRECTORY}/*.cpp
)

find_package(ireader-sdk CONFIG REQUIRED)
find_path(SDK_INCLUDE_DIR "ireader/sdk/sys/path.h" REQUIRED)

add_library(sip ${libsip_HEADER_FILES} ${libsip_SOURCE_FILES})
target_link_libraries(sip PUBLIC ireader::sdk::sdk ireader::sdk::http)
target_include_directories(sip PRIVATE ${libsip_INCLUDE_DIRECTORY} ${libsip_SOURCE_DIRECTORY})
target_include_directories(sip PRIVATE ${SDK_INCLUDE_DIR}/ireader/sdk ${SDK_INCLUDE_DIR}/ireader/sdk/http)

list(APPEND IREADER_MEDIA_SERVER_EXPORT_LIBS sip)
install(DIRECTORY ${libsip_INCLUDE_DIRECTORY}/ DESTINATION include/ireader/media-server/sip)
