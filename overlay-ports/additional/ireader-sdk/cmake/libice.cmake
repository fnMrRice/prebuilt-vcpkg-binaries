include_guard(GLOBAL)

set(libice_DIR ${CMAKE_CURRENT_SOURCE_DIR}/libice)
set(libice_INCLUDE_DIRECTORY ${libice_DIR}/include)
set(libice_SOURCE_DIRECTORY ${libice_DIR}/src)
set(libice_TEST_DIRECTORY ${libice_DIR}/test)

file(GLOB_RECURSE libice_HEADER_FILES
        ${libice_INCLUDE_DIRECTORY}/*.h
        ${libice_INCLUDE_DIRECTORY}/*.hxx
        ${libice_INCLUDE_DIRECTORY}/*.hpp
)
file(GLOB_RECURSE libice_SOURCE_FILES
        ${libice_SOURCE_DIRECTORY}/*.c
        ${libice_SOURCE_DIRECTORY}/*.cxx
        ${libice_SOURCE_DIRECTORY}/*.cpp
)

include(cmake/libsdk.cmake)

add_library(ice ${libice_HEADER_FILES} ${libice_SOURCE_FILES})
target_include_directories(ice PRIVATE ${libice_INCLUDE_DIRECTORY} ${libsdk_INCLUDE_DIRECTORY})
target_link_libraries(ice PUBLIC sdk)

list(APPEND IREADER_SDK_EXPORT_LIBS ice)
install(DIRECTORY ${libice_INCLUDE_DIRECTORY}/
        DESTINATION include/ireader/sdk/ice
        FILES_MATCHING REGEX "^.+\.h(pp|xx)?$"
)
